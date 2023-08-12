const hre = require("hardhat");
const { addr } = require("../addresses.js");


async function main() {
  
    const token = await hre.ethers.deployContract("TAS", []);
    await token.waitForDeployment();
    console.log("Token deployed to :", token.target);

    const tasteProtocol = await hre.ethers.deployContract("TasteProtocol", [addr.ZoraGoerliEAS, token.target, false]);
    console.log("TasteProtocol deployed to :", tasteProtocol.target);

  }
  
  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  