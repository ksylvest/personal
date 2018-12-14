const { environment } = require('@rails/webpacker');
const typescript = require('./loaders/typescript');

const loader = environment.loaders.get('file');
loader.test = /\.(jpg|jpeg|png|gif|tiff|ico|svg|eot|otf|ttf|woff|webp)$/i;

environment.loaders.append('typescript', typescript);

module.exports = environment;
