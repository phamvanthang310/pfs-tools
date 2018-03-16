import chalk from 'chalk';

export const normal = (str) => {
  console.log(chalk.white(chalk.bgBlackBright(str)));
};

export const highlightGreen = (str) => {
  console.log(chalk.bgGreenBright(chalk.white(str)));
};

export const highlightRed = (str) => {
  console.log(chalk.bgRedBright(chalk.white(str)));
};

export const info = (str) => {
  console.info(chalk.yellowBright(str));
};

export const debug = (str) => {
  console.log(chalk.blue(str));
};

export const error = (str) => {
  console.error(chalk.redBright(str));
};

export const success = (str) => {
  console.info(chalk.green(str));
};

export default {
  normal,
  highlightRed,
  highlightGreen,
  info,
  debug,
  error,
  success,
};