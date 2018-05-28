// @flow
import ConsoleStamp from 'console-stamp';
import GoogleClient from './GoogleClient';
import _ from 'lodash';
import logger from './utils/logger';
import fileUtils from './utils/file';
import path from 'path';

export default class PfsTool {
  textExtractRegex: RegExp;
  regex: RegExp;
  translator: any;
  target: string;
  srcDir: string;
  distDir: string;
  isExport: boolean;
  options: Object;
  basename: string;

  constructor(opts: OptionArgument) {
    ConsoleStamp(console, {
      pattern: 'dd/mm/yyyy HH:MM:ss.l',
      colors: {
        stamp: 'yellow',
        label: 'blue',
      },
    });
    this.regex = /^.*[\\|/]([\w]*).jsp.*$/gmi;
    this.textExtractRegex = /(<(?![\s\w]*script).*>)([^.#@!^&':;*,()?}][\s\w]*[\d\w.#@!$^&':;*,()?]+)[^>]*(<\/.*>)/gmi;
    this.translator = new GoogleClient(opts.target);
    this.target = opts.target;
    this.srcDir = opts.src;
    this.distDir = opts.dist;
    this.isExport = opts.export;
    this.basename = opts.basename;
    this.options = {
      flags: opts.overwrite ? 'w' : 'a',
      encoding: 'utf8',
      fd: null,
      autoClose: true
    };
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
    const tmp = this.regex.exec(filePath)[1];
    this.regex.lastIndex = 0;
    return tmp;
  }

  _buildPropKey(fileName: string, extractedText: string): string {
    // props format: <fileName>.<type>.<displayedText> = extractedText
    const maxWords: number = 8;
    const camelCaseWord = (text: string) => {
      const words = _.words(text).map(word => _.capitalize(word));
      const result = words.slice(0, maxWords).join('');
      return _.camelCase(result);
    };

    const propKey1 = _.camelCase(fileName);
    const propKey2 = camelCaseWord(extractedText);

    return `${propKey1}.text.${propKey2}`;
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

  exportCSV(path1: string, path2: string) {
    const file1 = fileUtils.readFileSync(path1);
    const file2 = fileUtils.readFileSync(path2);
    let list = [];
    let tmp: string[];

    const regex = /^(.*) = (.*)$/gmi;
    let map = new Map;

    while (tmp = regex.exec(file1)) {
      map.set(tmp[1], `${tmp[1]},${tmp[2]}`);
    }
    while (tmp = regex.exec(file2)) {
      let list = [];
      if (map.has(tmp[1])) {
        list.push(map.get(tmp[1]));
        list.push(tmp[2]);
        map.set(tmp[1], list.join(','))
      } else {
        map.set(tmp[1], `${tmp[1]},${tmp[2]}`)
      }
    }

    fileUtils.writeArrayToFile(`${this.distDir}/${this.basename}.csv`, Array.from(map.values()))
      .then(result => {
        if (result) logger.success(`[${this.basename}.csv] is exported successfully!`);
      })
      .catch(error => logger.error(error));
  }

  _processFile(filePath: string): void {
    fileUtils.readFile(filePath)
      .then(content => {
        const extractedTexts = this._extractText(content);
        if (!extractedTexts) {
          logger.error('Nothing to convert!!');
          return '';
        }
        return Promise.all([content, this.translator.translate([...extractedTexts])]);
      })
      .then(([content, translatedTexts]: [string, Array<ExtractedText>]) => {
        const fileName = this._extractFileName(filePath);
        logger.highlightGreen(`fileName: ${fileName}`);

        const propsMap = this._buildPropsMap(fileName, translatedTexts);

        this._exportPropsFile(this.basename, propsMap.origin);
        this._exportPropsFile(`${this.basename}_${this.target}`, propsMap.translated);
        this.options.flags = 'a';
        if (this.isExport) {
          this._exportCSVFile(fileName, propsMap);
        }

        this._replaceTextByTaglib(filePath, content, propsMap.origin);
      })
      .catch(error => {

        logger.error(`fail when processFile ${filePath}`);
        logger.error(error);
        return;
      });
  }

  _exportPropsFile(fileName: string, propsMap: Map<string, string>): void {
    const props: Array<string> = Array.from(propsMap, ([text, propKey]) => `${propKey} = ${text}`);

    props.push('');
    fileUtils.writeArrayToFile(`${this.distDir}/${fileName}.properties`, props, this.options)
      .then(result => {
        if (result) logger.success(`[${fileName}.properties] is exported successfully!`);
      })
      .catch(error => logger.error(error));
  }

  _exportCSVFile(fileName: string, propsMap: Object): void {
    const trans = propsMap.translated;
    const props: Array<string> = Array.from(propsMap.origin, ([text, propKey]) => `${propKey},${text},${trans.get(propKey)}`);

    fileUtils.writeArrayToFile(`${this.distDir}/${this.basename}.csv`, props, this.options)
      .then(result => {
        if (result) logger.success(`[${this.basename}.csv] is exported successfully!`);
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

  fixDuplicate(propsFilePath: string) {
    logger.info(`Fix duplicated for: ${this.srcDir}`);
    logger.info(`Properties file path: ${propsFilePath}`);

    Promise.all([this._processPropsFile(propsFilePath), this._readFileToMap(this.srcDir)]).then(([{ dupValues, originValues }, fileCache]) => {
      logger.success(`total dup props: ${dupValues.length}`);
      logger.success(`total file cached: ${fileCache.size}`);

      const newProps = [];
      const mapToProps = (value, key) => newProps.push(`${key} = ${value}`);
      this._processJavaAndPropsFile(fileCache, dupValues).forEach(mapToProps);

      // Update all files
      fileCache.forEach((content, filePath) => {
        fileUtils.writeFile(filePath, content);
      });

      // Write out props files
      originValues.forEach(mapToProps);
      fileUtils.writeArrayToFile(propsFilePath, newProps);

      logger.highlightGreen('Finished!');
    }).catch(error => logger.error(error))
  }

  _processPropsFile(propsFilePath: string): any {
    return new Promise((resolve, reject) => {
      fileUtils.isFile(propsFilePath).then(isFile => {
        if (isFile) {
          fileUtils.readFile(propsFilePath).then(content => {
            resolve(this._findDuplicatedProps(content));
          });
        } else {
          reject(`${propsFilePath} is not a file.`);
        }
      }).catch(error => {
        reject(`${propsFilePath} is not a file. \n ${error}`);
      });
    });
  }

  _findDuplicatedProps(data: string): { dupValues: Array<any>, originValues: Map<any, any> } {
    const values = [], dupValues = [], origin = new Map();
    const textExtractByLineReg = /^([^=]+)=(.+)$/gmi;
    let tmp;

    while (tmp = textExtractByLineReg.exec(data)) {
      const value = tmp[2].trim();
      const key = tmp[1].trim();
      origin.set(key, value);

      if (!values.includes(value)) {
        values.push(value);
      } else {
        dupValues.push({
          key, value
        });
      }
    }

    // remove duplicated value from origin map then write out
    dupValues.forEach(({ key }) => {
      if (origin.has(key))
        origin.delete(key)
    });

    return { dupValues, originValues: origin };
  }

  _readFileToMap(srcDir: string): any {
    return new Promise((resolve, reject) => {
      fileUtils.walkThoughDir(srcDir).then(filePaths => {
        const result = new Map();
        let pending = 0;

        filePaths = filePaths
          .filter(filePath => path.extname(filePath) === '.jsp' || path.extname(filePath) === '.java');

        filePaths.forEach((filePath, index) => {
          pending += 1;

          fileUtils.readFile(filePath).then(content => {

            pending -= 1;
            result.set(filePath, content);
            if (pending === 0 && index === filePaths.length - 1) {
              resolve(result);
            }
          }).catch(error => reject(error));
        });

      }).catch(error => reject(error));
    });
  }

  _processJavaAndPropsFile(fileCache: Map<string, string>, dupProps: Array<any>): Map<string, string> {
    const newProps = new Map();
    dupProps.forEach(({ value, key }) => {
      const regex = new RegExp(`${key}`, 'g');
      const newKey = key.replace(/(.*)[.](.*)[.](.*)/g, (match, g1, g2, g3) => `common.${g2}.${g3}`);
      const newCache = fileCache;

      fileCache.forEach((content, filePath) => {
        const newContent = content.replace(regex, `${newKey}`);
        newCache.set(filePath, newContent);
      });

      fileCache = newCache;
      newProps.set(newKey, value);
    });

    return newProps;
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
  overwrite: boolean,
  export: boolean,
  basename: string,
}

type Property = {
  origin: Map<string, string>,
  translated: Map<string, string>,
}