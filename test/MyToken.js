const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("My Token", function () {
  async function deployTokenFixture() {
    const Token = await ethers.getContractFactory("MyToken");
    const [owner, addr1, addr2] = await ethers.getSigners();
    const myToken = await Token.deploy();
    await myToken.waitForDeployment();
    return { Token, myToken, owner, addr1, addr2 };
  }

    describe("Deployment", function () {
        it("Should assign the total supply of tokens to the contract creator", async function () {
            const { myToken, owner } = await loadFixture(deployTokenFixture);
            const ownerBalance = await myToken.balanceOf(owner.address);
            expect(await myToken.totalSupply()).to.equal(ownerBalance);
        });
    });

    describe("Transfer Function", function () {
        it("Should fail if value is zero", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);
            const initialOwnerBalance = await myToken.balanceOf(owner.address);
            const initialAddr1Balance = await myToken.balanceOf(addr1.address);

            await expect(
                myToken.transfer(addr1.address, 0)
            ).to.be.revertedWith("Transfer amount must be greater than zero");

            expect(await myToken.balanceOf(owner.address)).to.equal(initialOwnerBalance);
            expect(await myToken.balanceOf(addr1.address)).to.equal(initialAddr1Balance);
        });

        it("Should fail if value is greater than sender's balance", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);
            const initialOwnerBalance = await myToken.balanceOf(owner.address);
            const initialAddr1Balance = await myToken.balanceOf(addr1.address);

            const value = ethers.parseUnits("1", 0);
            await expect(
                myToken.connect(addr1).transfer(owner.address, value)
            ).to.be.revertedWith("Insufficient balance");

            expect(await myToken.balanceOf(owner.address)).to.equal(initialOwnerBalance);
            expect(await myToken.balanceOf(addr1.address)).to.equal(initialAddr1Balance);
        });
    });
});