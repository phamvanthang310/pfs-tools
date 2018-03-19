// @flow

import ConsoleStamp from 'console-stamp';
import GoogleClient from './GoogleClient';
import _ from 'lodash';
import logger from './utils/logger';
import fileUtils from './utils/file';

export default class PfsTool {
  textExtractRegex: RegExp;
  translator: any;
  target: string;
  srcDir: string;
  distDir: string;

  constructor(opts: OptionArgument) {
    ConsoleStamp(console, {
      pattern: 'dd/mm/yyyy HH:MM:ss.l',
      colors: {
        stamp: 'yellow',
        label: 'blue',
      },
    });
    logger.debug(opts.src);

    this.textExtractRegex = /(<(?![\s\w]*script).*>)([^.#@!^&':;*,()?}][\s\w]*[\d\w.#@!$^&':;*,()?]+)[^>]*(<\/.*>)/gmi;
    this.translator = new GoogleClient(opts.target);
    this.target = opts.target;
    this.srcDir = opts.src;
    this.distDir = opts.dist;
  }

  start(): void {
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

  _processDirectory(): void {
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

  _extractText(data: string): Array<string> {
    const result = [];
    let tmp;

    while (tmp = this.textExtractRegex.exec(data)) {
      result.push(tmp[2].trim());
    }

    return result;
  }

  _extractFileName(filePath: string): string {
    const regex = /^.*\/([\w]*).jsp$/gmi;
    return regex.exec(filePath)[1];
  }

  _buildPropKey(fileName: string, extractedText: string): string {
    // props format: file.name.extracted.text = extractedText
    // props key: word by word
    const toWordByWord = (text: string) => _.words(text).map(word => word.toLowerCase()).join('.');

    const propKey1 = toWordByWord(fileName);
    const propKey2 = toWordByWord(extractedText);

    return `${propKey1}.${propKey2}`;
  }

  _buildPropsMap(fileName: string, extractedTexts: any): Property {
    const origin: Map<string, string> = new Map();
    const translated: Map<string, string> = new Map();

    // Convert extractedTexts into array when it has one text
    if (!_.isArray(extractedTexts)) {
      extractedTexts = [extractedTexts];
    }

    extractedTexts.forEach((extractedText: ExtractedText) => {
      const propKey: string = this._buildPropKey(fileName, extractedText.originalText);

      // To make sure each text is unique, text is the key of map
      origin.set(extractedText.originalText, propKey);
      translated.set(extractedText.translatedText, propKey);
    });

    return {
      origin,
      translated,
    };
  }

  _processFile(filePath: string): void {
    fileUtils.readFile(filePath)
      .then(content => {
        const extractedTexts = this._extractText(content);

        return Promise.all([content, this.translator.translate([...extractedTexts])]);
      })
      .then(([content, translatedTexts]: [string, Array<ExtractedText>]) => {
        const fileName = this._extractFileName(filePath);
        logger.highlightGreen(`fileName: ${fileName}`);

        const propsMap = this._buildPropsMap(fileName, translatedTexts);

        this._exportPropsFile(fileName, propsMap.origin);
        this._exportPropsFile(`${fileName}_${this.target}`, propsMap.translated);

        this._replaceTextByTaglib(filePath, content, propsMap.origin);
      })
      .catch(error => {
        logger.error(`fail when processFile ${filePath}`);
        logger.error(error);
        process.exit(-1);
      });
  }

  _exportPropsFile(fileName: string, propsMap: Map<string, string>): void {
    const props: Array<string> = Array.from(propsMap, ([text, propKey]) => `${propKey} = ${text}`);

    fileUtils.writeArrayToFile(`${this.distDir}/${fileName}.properties`, props)
      .then(result => {
        if (result) logger.success(`[${fileName}.properties] is exported successfully!`);
      })
      .catch(error => logger.error(error));
  }

  _replaceTextByTaglib(filePath: string, content: string, propsMap: Map<string, string>): string {
    const replacer = (match, g1, g2, g3) => {
      const propKey = propsMap.get(g2) || g2;
      return `${g1}<fmt:message key="${propKey}" />${g3}`;
    };

    const newContent = content.replace(this.textExtractRegex, replacer);
    fileUtils.writeFile(filePath, newContent);

    return newContent;
  }
}

type ExtractedText = {
  originalText: string,
  translatedText: string,
}

type OptionArgument = {
  target: string,
  src: string,
  dist: string,
}

type Property = {
  origin: Map<string, string>,
  translated: Map<string, string>,
}