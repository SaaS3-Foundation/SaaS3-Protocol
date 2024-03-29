import { ethers } from "hardhat"

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const CoinPrice = await ethers.getContractFactory("CoinPrice");
    const c = await CoinPrice.attach('0x7cAf6684538d6DfBfa72fA0f2cFb504059724A32');
    console.log("CoinPrice Contract address:", c.address);
    await c.connect(deployer).set_oracle('0x03B456708e05B447d88Ae4EaC0A0afF66f8d166a', '0x962D0Ca297F21f027E9d25613F2D53aAa31F5fCC');
}

main();
