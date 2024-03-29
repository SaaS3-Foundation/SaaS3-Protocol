import "@nomicfoundation/hardhat-toolbox";
import { HardhatUserConfig } from 'hardhat/types';

const MNEMONIC = process.env.MNEMONIC

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
      moon: {
        url: "https://rpc.api.moonbase.moonbeam.network",
        accounts: { mnemonic: MNEMONIC }
      },
      polygon: {
        url: "https://rpc.ankr.com/polygon",
        accounts: { mnemonic: MNEMONIC }
      },
      bnb: {
        url: "https://bsc-dataseed.binance.org/",
        accounts: { mnemonic: MNEMONIC },
 gas: 2100000,
      gasPrice: 8000000000
      }
  },
  solidity: '0.8.9'
};

export default config;
