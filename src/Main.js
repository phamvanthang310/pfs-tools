import PfsTool from './PfsTool';
import yargs from 'yargs';
import GoogleClient from './GoogleClient';
import logger from './utils/logger';

yargs
  .usage('node $0 <commands> [args]')
  .options({
    'dist': {
      alias: 'd',
      default: './dist',
      describe: 'Exported file destination directory',
    },
    'target': {
      alias: 't',
      default: 'zh',
      describe: 'Target language for translation',
    }
  })
  .command('scan [src]', 'Run tool to scan directory/file', {},
    (opts) => {
      const app = new PfsTool(opts);
      app.start();
    })
  .command('translate [text]', 'Translate a english text to specify language (default is zh)', {},
    (opts) => {
      const googleClient = new GoogleClient(opts.target);
      googleClient.translate(opts.text)
        .then(result => {
          logger.info(result.translatedText);
        })
        .catch(err => logger.error(err));
    })
  .demandCommand(1, 'You need at least one command before moving on')
  .recommendCommands()
  .epilogue('For more information, see https://github.com/phamvanthang310/PFS-tools')
  .help()
  .argv;
