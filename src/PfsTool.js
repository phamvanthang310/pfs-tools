import ConsoleStamp from 'console-stamp';
import GoogleClient from './GoogleClient';
import _ from 'lodash';
import logger from './utils/logger';
import fileUtils from './utils/file';

export default class PfsTool {

  constructor(opts) {
    ConsoleStamp(console, {
      pattern: 'dd/mm/yyyy HH:MM:ss.l',
      colors: {
        stamp: 'yellow',
        label: 'blue',
      },
    });
    logger.debug(opts.src);

    this.translator = new GoogleClient(opts.target);
    this.target = opts.target;
    this.srcDir = opts.src;
    this.distDir = opts.dist;
  }

  start() {
    fileUtils.isFile(this.srcDir).then(result => {
      fileUtils.createDirectory(this.distDir);

      if (result) {
        this._processFile(this.srcDir);
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
    fileUtils.walkThoughDir(this.srcDir)
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
        logger.error(`Fail when process directory: ${this.srcDir}`);
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
    const originProps = new Set();
    const translatedProps = new Set();

    const propKey1 = _.words(fileName).map(word => word.toLowerCase()).join('.');

    // Convert extractedTexts into array when it has one text
    if (!_.isArray(extractedTexts)) extractedTexts = [extractedTexts];

    for (let extractedText of extractedTexts) {
      const contentWords = _.words(extractedText.originalText).map(word => word.toLowerCase());
      const propKey = `${propKey1}.${contentWords.join('.')}`;

      originProps.add(`${propKey} = ${extractedText.originalText}`);
      translatedProps.add(`${propKey} = ${extractedText.translatedText}`);
    }

    return {
      origin: Array.from(originProps),
      translated: Array.from(translatedProps)
    };
  }

  _processFile(filePath) {
    fileUtils.readFile(filePath)
      .then(content => {
        const fileName = this._extractFileName(filePath);
        const extractedTexts = this._extractText(content);
        logger.highlightGreen(`fileName: ${fileName}`);

        this._translateExtractedTexts(fileName, extractedTexts);
      })
      .catch(error => {
        logger.error(`fail when processFile ${filePath}`);
        logger.error(error);
        process.exit(-1);
      });
  }

  _translateExtractedTexts(fileName, texts) {
    this.translator.translate([...texts])
      .then(extractedTexts => {
        const props = this._buildProps(fileName, extractedTexts);

        this._exportPropsFile(fileName, props.origin);
        this._exportPropsFile(`${fileName}_${this.target}`, props.translated);
      })
      .catch(error => logger.error(error));
  }

  _exportPropsFile(fileName, props) {
    fileUtils.writeFile(`${this.distDir}/${fileName}.properties`, props)
      .then(result => {
        if (result) logger.success(`[${fileName}.properties] is exported successfully!`);
      })
      .catch(error => logger.error(error));
  }
}
