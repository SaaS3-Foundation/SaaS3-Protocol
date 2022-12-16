import { ethers } from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const FootballGame = await ethers.getContractFactory("FootballGame");
    const c = await FootballGame.attach('0x06f3465526c7503BD3218EbEd3979f2DBd46a190');
    console.log("FootballGame contract address:", c.address);
    await c.connect(deployer).set_oracle('0xFcE6C1a1e539ED4B6594F1a0f7b60a7853Fb479C', '0x63De844992279204a7132C936EF07c27A770D809', '0x2F63e9b523Df4e7d817860c1dda60279b46cC0cd');
}

main();