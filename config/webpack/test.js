process.env.NODE_ENV = process.env.NODE_ENV || 'development';

const environment = require('./environment');
const ForkTSCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');

const FORK_TS_CHECKER = new ForkTSCheckerWebpackPlugin({ async: false });
environment.plugins.append('fork-ts-checker', FORK_TS_CHECKER);

module.exports = environment.toWebpackConfig();
