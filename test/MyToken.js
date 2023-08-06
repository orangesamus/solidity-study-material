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

            await expect(
                myToken.transfer(addr1.address, 0)
            ).to.be.revertedWith("Transfer amount must be greater than zero");
        });

        it("Should fail if value is greater than sender's balance", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            const value = ethers.parseUnits("1", 0);
            await expect(
                myToken.connect(addr1).transfer(owner.address, value)
            ).to.be.revertedWith("Insufficient balance");
        });

        it("Should update token balances", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            const value = ethers.parseUnits("50", 0);
            await expect(myToken.transfer(addr1.address, value)).to.changeTokenBalances(
                myToken,
                [owner, addr1],
                [-50,50]
            );
        });

        it("Should emit Transfer event", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            const value = ethers.parseUnits("50", 0);
            await expect(myToken.transfer(addr1.address, value))
            .to.emit(myToken, "Transfer").withArgs(owner.address, addr1.address, value);
        });
    });

    describe("TransferFrom Function", function () {
        it("Should fail if value is zero", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            await expect(
                myToken.transferFrom(owner.address, addr1.address, 0)
            ).to.be.revertedWith("Transfer amount must be greater than zero");
        });

        it("Should fail if value is greater than sender's balance", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            const value = ethers.parseUnits("1", 0);
            await expect(
                myToken.transferFrom(addr1.address, owner.address, value)
            ).to.be.revertedWith("Insufficient balance");
        });
        
        describe("Approve Function", function () {
            it("Should update allowances", async function () {
                const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

                const value = ethers.parseUnits("50", 0);
                await myToken.approve(addr1.address, value);
                expect(await myToken.allowance(owner.address, addr1.address)).to.equal(value);
            });

            it("Should emit Approval event", async function () {
                const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

                const value = ethers.parseUnits("50", 0);
                await expect(myToken.approve(addr1.address, value))
                .to.emit(myToken, "Approval").withArgs(owner.address, addr1.address, value);
            });
        });

        it("Should fail if value exceeds allowances", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            const value = ethers.parseUnits("50", 0);
            const exceedValue = ethers.parseUnits("51", 0);
            await myToken.approve(addr1.address, value);
            await expect(
                myToken.connect(addr1).transferFrom(owner.address, addr1.address, exceedValue)
            ).to.be.revertedWith("Transfer amount exceeds allowance");
        });

        it("Should update token balances", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            const value = ethers.parseUnits("50", 0);
            await myToken.approve(addr1.address, value);
            await expect(
                myToken.connect(addr1).transferFrom(owner.address, addr1.address, value)
            ).to.changeTokenBalances(
                myToken,
                [owner, addr1],
                [-50,50]
            );
        });

        it("Should update allowances", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            const value = ethers.parseUnits("50", 0);
            await myToken.approve(addr1.address, value);
            await myToken.connect(addr1).transferFrom(owner.address, addr1.address, value);
            expect(await myToken.allowance(owner.address, addr1.address)).to.equal(0);
        });

        it("Should emit Transfer event", async function () {
            const { myToken, owner, addr1 } = await loadFixture(deployTokenFixture);

            const value = ethers.parseUnits("50", 0);
            await myToken.approve(addr1.address, value);
            await expect(
                myToken.connect(addr1).transferFrom(owner.address, addr1.address, value)
            ).to.emit(myToken, "Transfer").withArgs(owner.address, addr1.address, value);
        });
    });
});