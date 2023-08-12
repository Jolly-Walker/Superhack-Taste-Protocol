const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { addr } = require("../addresses.js");
const { ethers } = require("hardhat");

describe("Taste Protocol", function () {
  async function deployTasteProtocolFixture() {

    // Contracts are deployed using the first signer/account by default
    const [owner, ...accounts] = await ethers.getSigners();

    const TokenFactory = await ethers.getContractFactory("TAS");
    const token = await TokenFactory.deploy();
    const TasteProtocolFactory = await ethers.getContractFactory("TasteProtocol");
    const tasteProtocol = await TasteProtocolFactory.deploy(addr.OpGoerliEAS, await token.getAddress(), false);

    return {token, tasteProtocol, owner, accounts};
  }

  describe("Unit Test", function () {
    it("Simple Flow", async function () {
      const { token, tasteProtocol, owner, accounts } = await loadFixture(deployTasteProtocolFixture);
      await token.approve(await tasteProtocol.getAddress(), ethers.parseEther('10'));
      await tasteProtocol.requestRecipe("Chicken Rice", await time.latest() + 5, ethers.parseEther("10"));

      await tasteProtocol.connect(accounts[0]).fulfilRequest(0, "Chicken Rice", "ipfs://cid/");
      await tasteProtocol.connect(accounts[1]).fulfilRequest(0, "Chicken Rice", "ipfs://cid2/");
      await tasteProtocol.connect(accounts[2]).fulfilRequest(0, "Chicken Rice", "ipfs://cid3/");

      await tasteProtocol.connect(accounts[3]).voteRecipe(0, "Chicken Rice", accounts[1].address);
      await tasteProtocol.connect(accounts[4]).voteRecipe(0, "Chicken Rice", accounts[2].address);
      await tasteProtocol.connect(accounts[6]).voteRecipe(0, "Chicken Rice", accounts[1].address);

      await tasteProtocol.decideWinner(0, "Chicken Rice", accounts[2].address);
      expect((await token.balanceOf(accounts[1].address)).toString()).to.equal(ethers.parseEther("5").toString());
      expect((await token.balanceOf(accounts[2].address)).toString()).to.equal(ethers.parseEther("5").toString());

    });

    // it("Submit Recipe", async function () {
    //   const { token, tasteProtocol, owner, accounts } = await loadFixture(deployTasteProtocolFixture);


    //   expect(await lock.owner()).to.equal(owner.address);
    // });

    // it("Vote Recipe", async function () {
    //   const { token, tasteProtocol, owner, accounts } = await loadFixture(deployTasteProtocolFixture);

    // });

    // it("Decide Recipe Winner", async function () {
    //   const { token, tasteProtocol, owner, accounts } = await loadFixture(deployTasteProtocolFixture);
    // });
  });
});
