import {ethers} from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Ask = await ethers.getContractFactory("Ask");
    const ask = await Ask.deploy();
  
    console.log("Ask contract address:", ask.address);
}
  
main();