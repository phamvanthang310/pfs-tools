import fs from 'fs';

const walkThoughDir = (rootDir) => {
  const walk = function (dir, done) {
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

  return new Promise((resolve, reject) => {
    walk(rootDir, function (err, results) {
      if (err) reject(err);
      resolve(results);
    });
  });
};

const readFile = (path) => {
  return new Promise((resolve, reject) => {
    fs.readFile(path, {encoding: 'utf8'}, (err, data) => {
      if (err) reject(err);
      resolve(data);
    });
  });
};

const isFile = (path) => {
  return new Promise((resolve, reject) => {
    fs.stat(path, (err, stat) => {
      if (err) reject(err);
      resolve(stat && stat.isFile());
    });
  });
};

const writeArrayToFile = (fileName, array, options) => {
  return writeFileStream(fileName, array.join('\n'), options);
};

const writeFile = (filePath, data) => {
  return new Promise((resolve, reject) => {
    fs.writeFile(filePath, data, (err) => {
      if (err) reject(err);
      resolve(true);
    });
  });
};

const writeFileStream = (filePath, data, options) => {
  let writerStream = fs.createWriteStream(filePath, options);
  return new Promise((resolve, reject) => {
    writerStream.write(data, (err) => {
      if (err) reject(err);
      resolve(true);
    });
  });
};

const readFileSync = (filePath) => {
  return fs.readFileSync(filePath);
};

const createDirectory = (dir) => {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir);
};

export default {
  walkThoughDir,
  readFile,
  readFileSync,
  writeArrayToFile,
  writeFile,
  isFile,
  createDirectory,
};