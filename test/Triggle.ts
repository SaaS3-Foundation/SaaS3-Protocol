import { ethers } from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Connect contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const FootballGame = await ethers.getContractFactory("FootballGame");
    const c = FootballGame.attach('0x06f3465526c7503BD3218EbEd3979f2DBd46a190');
    console.log("FootballGame contract address:", c.address);
    let receipt = await c.connect(deployer).triggle('0x000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000012312e20464320556e696f6e204265726c696e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b4643204175677362757267000000000000000000000000000000000000000000');
    console.log(receipt);
}

main();