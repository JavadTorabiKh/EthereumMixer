require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.0", // Specify the Solidity version
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337, // Default Hardhat network chain ID
    },
    ropsten: {
      url: process.env.ROPSTEN_URL, // Infura or Alchemy URL for Ropsten
      accounts: [process.env.PRIVATE_KEY], // Private key of the deployer account
    },
    mainnet: {
      url: process.env.MAINNET_URL, // Infura or Alchemy URL for Mainnet
      accounts: [process.env.PRIVATE_KEY], // Private key of the deployer account
    },
  },
  mocha: {
    timeout: 20000, // Set timeout for tests
  },
};