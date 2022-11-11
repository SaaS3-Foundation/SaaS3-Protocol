import {ethers} from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Askv0 = await ethers.getContractFactory("Askv0");
    const c = await Askv0.deploy();
  
    console.log("Askv0 contract address:", c.address);
}
  
main();