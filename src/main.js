import ConsoleStamp from 'console-stamp';
import _ from 'lodash';
import { default as logger } from './utils/logger';
import { default as fileUtils } from './utils/file';

class Main {

  // Ignored the 2 very first arguments (node and js endpoint as always)
  constructor([, , ...programArgs]) {
    ConsoleStamp(console, {
      pattern: 'dd/mm/yyyy HH:MM:ss.l',
      colors: {
        stamp: 'yellow',
        label: 'blue',
      },
    });
    logger.debug(programArgs);
    this.rootDir = programArgs[0]; // First argument is path
    this.distDir = './dist';
  }

  start() {
    fileUtils.isFile(this.rootDir).then(result => {
      fileUtils.createDirectory(this.distDir);

      if (result) {
        this._processFile(this.rootDir);
      } else {
        this._processDirectory();
      }
    }).catch(error => {
      logger.error('Fail when executed fs.stat');
      logger.error(error);
      process.exit(-1);
    });
  }

  _processDirectory() {
    fileUtils.walkThoughDir(this.rootDir)
      .then((results) => {
        // Filter out .jsp files
        results = results.filter(filePath => /^(.*\.((jsp)$)).*$/.test(filePath));
        for (let result of results) {
          logger.normal(result);
          this._processFile(result);
        }
        logger.highlightGreen(`Total: ${results.length}`);
      })
      .catch(error => {
        logger.error(`Fail when process directory: ${this.rootDir}`);
        logger.error(error);
        process.exit(-1);
      });
  }

  _extractText(data, callback) {
    // const regex = /<.*>([^.#@!$^&':;*,()}][\s\w]*[\d\w.#@!$^&':;*,()]+)[^>]*<\/.*>/gmi;
    const regex = /<(?![\s\w]*script).*>([^.#@!^&':;*,()?}][\s\w]*[\d\w.#@!$^&':;*,()?]+)[^>]*<\/.*>/gmi;
    const result = [];
    let tmp;
    while (tmp = regex.exec(data)) {
      result.push(tmp[1].trim());
      if (callback && typeof callback === 'function') callback(tmp);
    }
    return result;
  }

  _extractFileName(filePath) {
    const regex = /^.*\/([\w]*).jsp$/gmi;
    return regex.exec(filePath)[1];
  }

  _buildProps(fileName, extractedTexts) {
    // props format: file.name.extracted.text = extractedText
    // props key: word by word
    const props = new Set();
    const fileWords = _.words(fileName).map(word => word.toLowerCase());
    const propKey1 = fileWords.join('.');

    for (let extractedText of extractedTexts) {
      const contentWords = _.words(extractedText).map(word => word.toLowerCase());
      const propKey2 = contentWords.join('.');

      const prop = `${propKey1}.${propKey2} = ${extractedText}`;
      props.add(prop);
    }

    props.forEach(p => logger.normal(p));
    return Array.from(props);
  }

  _processFile(filePath) {
    fileUtils.readFile(filePath)
      .then(data => {
        const fileName = this._extractFileName(filePath);
        const content = this._extractText(data);
        logger.highlightGreen(`fileName: ${fileName}`);

        const props = this._buildProps(fileName, content);
        fileUtils.writeFile(`${this.distDir}/${fileName}.properties`, props)
          .then(result => {
            if (result) logger.success(`[${fileName}.properties] is exported successfully!`);
          })
          .catch(error => logger.error(error));
      })
      .catch(error => {
        logger.error(error);
        process.exit(-1);
      });
  }
}

if (process.argv.length <= 2) {
  logger.error(`Usage: npm start [path/to/directory]`);
  process.exit(-1);
}

const app = new Main(process.argv);
app.start();
