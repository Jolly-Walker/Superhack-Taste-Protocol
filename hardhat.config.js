require("@nomicfoundation/hardhat-toolbox");
const { privateKey } = require('./secrets.json');

module.exports = {
  networks: {
    localhost: {
      chainId: 31337,
      url: "http://127.0.0.1:8545",
    },
    opGoerli: {
      chainId: 420,
      url : "https://goerli.optimism.io",
      accounts : [privateKey]
    },
    baseGoerli: {
      chainId: 84531,
      url : "https://goerli.base.org",
      accounts : [privateKey]
    },
    zoraGoerli: {
      chainId: 999,
      url : "https://goerli.optimism.io",
      accounts : [privateKey]
    },
    modeSepolia: {
      chainId: 919,
      url : "https://sepolia.mode.network/",
      accounts : [privateKey]
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
