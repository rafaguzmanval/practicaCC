

const { parentPort } = require("worker_threads");
const crypto = require('crypto');

var hash = ""
let i = 0;
for(; i < 10000000; i++)
{
    hash = crypto.createHash('sha512').update('3ffafd').digest('base64');
}

parentPort.postMessage(hash);