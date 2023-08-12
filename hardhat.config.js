require("@nomicfoundation/hardhat-toolbox");
const { privateKey} = require('./secrets.json');

module.exports = {
  networks: {
    localhost: {
      chainId: 31337,
      url: "http://127.0.0.1:8545",
    },
  },
  solidity: {
    version: "0.8.17",
    settings: {
      viaIR: false,
      optimizer: {
        enabled: true,
        runs: 200
      }
    },
  }
};
