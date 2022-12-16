import { ethers } from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const CoinPrice = await ethers.getContractFactory("CoinPrice");
    const c = await CoinPrice.attach('0xcc8A8236eABFeb533b96008A712BB7f16C38775C');
    console.log("CoinPrice contract address:", c.address);
    await c.connect(deployer).set_oracle('0xFcE6C1a1e539ED4B6594F1a0f7b60a7853Fb479C', '0x63De844992279204a7132C936EF07c27A770D809');
}

main();