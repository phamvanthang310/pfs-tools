import PfsTool from './PfsTool';
import yargs from 'yargs';

yargs
  .usage('$0 <cmd> [args]')
  .options({
    'dist': {
      alias: 'd',
      default: './dist',
      describe: 'Exported file destination directory',
    }
  })
  .command('scan [path]', 'Run tool to scan directory/file', {},
    (opts) => {
      console.dir(opts);
      const app = new PfsTool(opts.path, opts.dist);
      app.start();
    })
  .demandCommand(1, 'You need at least one command before moving on')
  .recommendCommands()
  .epilogue('For more information, see https://github.com/phamvanthang310/PFS-tools')
  .help()
  .argv;
