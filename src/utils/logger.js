import chalk from 'chalk';

export const normal = (str) => {
    return chalk.white(str);
};

export const logNormal = (str) => {
    console.log(normal(chalk.bgBlackBright(str)));
};

export const highlight = (str) => {
    return chalk.bgRedBright(chalk.white(str));
};

export const logHighlight = (str) => {
    console.log(highlight(str));
};

export const info = (str) => {
    return chalk.yellowBright(str);
};

export const logInfo = (str) => {
    console.log(info(str));
};

export const debug = (str) => {
    return chalk.white(str);
};

export const logDebug = (str) => {
    console.log(debug(str));
};

export const error = (str) => {
    return chalk.redBright(str);
};

export const errorH = (str) => {
    return chalk.bgRedBright(str);
};

export const logError = (str) => {
    console.log(error(str));
};

export const errorToString = (err) => {
    if (err.message) {
        return JSON.stringify(err.message, null, '\t');
    }

    return JSON.stringify(err, null, '\t');
};


export default {
    normal,
    logNormal,
    highlight,
    errorToString,
    logHighlight,
    info,
    logInfo,
    debug,
    logDebug,
    error,
    logError,
    errorH
};