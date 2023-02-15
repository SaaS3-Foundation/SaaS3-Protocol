import {ethers} from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const CoinPrice = await ethers.getContractFactory("CoinPrice");
    const coinPrice = await CoinPrice.deploy();
  
    console.log("CoinPrice contract address:", coinPrice.address);
}
  
main();