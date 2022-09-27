import "@nomicfoundation/hardhat-toolbox";
import { HardhatUserConfig } from 'hardhat/types';

const MNEMONIC = process.env.MNEMONIC

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
      moon: {
        url: "https://rpc.api.moonbase.moonbeam.network",
        accounts: { mnemonic: MNEMONIC }
      }
  },
  solidity: '0.8.9'
};

export default config;