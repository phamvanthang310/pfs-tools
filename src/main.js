import ConsoleStamp from 'console-stamp';
import _ from 'lodash';
import { default as logger } from './utils/logger';
import { default as fileUtils } from './utils/file';

class Main {

  // Ignored the 2 very first arguments (node and js endpoint as always)
  constructor([, , ...programArgs]) {
    ConsoleStamp(console, { pattern: 'dd/mm/yyyy HH:MM:ss.l' });
    logger.logDebug(programArgs);
    this.rootDir = programArgs[0]; // First argument is path
  }

  start() {
    fileUtils.isFile(this.rootDir).then(result => {
      if (result) {
        this._processFile(this.rootDir);
      } else {
        this._processDirectory();
      }
    }).catch(error => {
      logger.logError('Fail when executed fs.stat');
      logger.logError(error);
      process.exit(-1);
    });
  }

  _processDirectory() {
    fileUtils.walkThoughDir(this.rootDir)
      .then((results) => {
        // Filter out .jsp files
        results = results.filter(filePath => /^(.*\.((jsp)$)).*$/.test(filePath));
        for (let result of results) {
          logger.logNormal(result);
          // const filePath = '/home/thangpham/Documents/Working_Space/Core-Informatics/pfs-webapp/pfs-war/src/main/webapp/core/CellDetails.jsp';
          this._processFile(result);
        }
        logger.logHighlight(`Total: ${results.length}`);
      })
      .catch(error => {
        logger.logError(`Fail when process directory: ${this.rootDir}`);
        logger.logError(error);
        process.exit(-1);
      });
  }

  _extractText(data, callback) {
    // const regex = /<.*>([^.#@!$^&':;*,()}][\s\w]*[\d\w.#@!$^&':;*,()]+)[^>]*<\/.*>/gmi;
    const regex = /<(?![\s\w]*script).*>([^.#@!^&':;*,()}][\s\w]*[\d\w.#@!$^&':;*,()]+)[^>]*<\/.*>/gmi;
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
    const fileWords = _.words(fileName).map(word => word.toLowerCase());
    const propsKey1 = fileWords.join('.');

    for (let extractedText of extractedTexts) {
      const contentWords = _.words(extractedText).map(word => word.toLowerCase());
      const propsKey2 = contentWords.join('.');

      logger.logHighlight(`${propsKey1}.${propsKey2} = ${extractedText}`);
    }
  }

  _processFile(filePath) {
    fileUtils.readFile(filePath)
      .then(data => {
        const fileName = this._extractFileName(filePath);
        const content = this._extractText(data);
        logger.logNormal(`fileName: ${fileName}`);
        // logger.logNormal(`content: ${content}`);
        this._buildProps(fileName, content);
      })
      .catch(error => {
        logger.logError(error);
        process.exit(-1);
      });
  }
}

if (process.argv.length <= 2) {
  logger.logError(`Usage: npm start [path/to/directory]`);
  process.exit(-1);
}

const app = new Main(process.argv);
app.start();
