import ConsoleStamp from 'console-stamp';
import fs from 'fs';
import { default as logger, logDebug, logInfo } from './utils/logger';

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

    this.walkThoughDir();
  }

  walkThoughDir() {
    let walk = function (dir, done) {
      let results = [];
      fs.readdir(dir, function (err, list) {
        if (err) return done(err);
        let i = 0;
        (function next() {
          let file = list[i++];
          if (!file) return done(null, results);
          file = dir + '/' + file;
          fs.stat(file, function (err, stat) {
            if (stat && stat.isDirectory()) {
              walk(file, function (err, res) {
                results = results.concat(res);
                next();
              });
            } else {
              results.push(file);
              next();
            }
          });
        })();
      });
    };

    walk(this.rootDir, function (err, results) {
      if (err) throw err;
      for (let result of results) {
        logger.logNormal(result);
      }
    });
  }

}

const app = new Main(process.argv);
app.start();
