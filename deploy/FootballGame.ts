import {ethers} from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const FootballGame = await ethers.getContractFactory("FootballGame");
    const c = await FootballGame.deploy();
  
    console.log("FootballGame contract address:", c.address);
}
  
main();