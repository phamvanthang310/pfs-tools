import ConsoleStamp from 'console-stamp';
import { default as logger } from './utils/logger';
import { default as fileUtils } from './utils/file';

class Main {

  // Ignored the 2 very first arguments (node and js endpoint as always)
  constructor([, , ...programArgs]) {
    ConsoleStamp(console, { pattern: 'dd/mm/yyyy HH:MM:ss.l' });
    logger.logDebug(programArgs);
    this.rootDir = programArgs[0]; // First argument is rootDir
  }

  start() {
    logger.logHighlight('log high light');
    logger.logNormal('log normal');
    logger.logError('log error');
    logger.logInfo('log info');

    fileUtils.walkThoughDir(this.rootDir)
      .then((results) => {
        // Filter out .jsp files
        results = results.filter(filePath => /^(.*\.((jsp)$)).*$/.test(filePath));
        for (let result of results) {
          logger.logNormal(result);
        }
        logger.logHighlight(results.length);
      })
      .catch(error => {
        logger.logError(error);
        process.exit(-1);
      });

    fileUtils.readFile('/home/thangpham/Documents/Working_Space/Core-Informatics/pfs-webapp/pfs-war/src/main/webapp/core/Login.jsp')
      .then(data => {
        logger.logNormal(this.extractText(data));
      })
      .catch(error => {
        logger.logError(error);
        process.exit(-1);
      });
  }

  extractText(data) {
    const regEx = /<[^>]+>*/gmi;
    return data.replace(regEx, '');
  }
}

if (process.argv.length <= 2) {
  logger.logError(`Usage: npm start [path/to/directory]`);
  process.exit(-1);
}

const app = new Main(process.argv);
app.start();
