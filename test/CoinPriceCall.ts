import { ethers } from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const CoinPrice= await ethers.getContractFactory("CoinPrice");
    const c = await CoinPrice.attach('0x7cAf6684538d6DfBfa72fA0f2cFb504059724A32');
    console.log("CoinPrice Contract address:", c.address);
    await c.connect(deployer).ask();
}

main();
