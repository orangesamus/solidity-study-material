const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("DAO Room", function () {

    async function deployDAORoomFixture() {
        const DAORoom = await ethers.getContractFactory("DAORoom");
        const [owner, addr1] = await ethers.getSigners();
        const room = await DAORoom.deploy();
        await room.waitForDeployment();
        return { room, owner, addr1 };
    }

    // Create a function to handle room rental
    async function rentRoom(room, renter) {
        const cost = ethers.parseUnits("1", "wei");
        const tx = await room.connect(renter).rent({ value: cost });
        const receipt = await tx.wait();
        return { receipt, cost };
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { room, owner } = await loadFixture(deployDAORoomFixture);
            expect(await room.owner()).to.equal(owner.address);
        });

        it("Should cost 1 wei to rent", async function () {
            const { room, owner } = await loadFixture(deployDAORoomFixture);
            expect(await room.cost()).to.equal(1);
        });

        it("Should start as a vacant room", async function () {
            const { room, owner } = await loadFixture(deployDAORoomFixture);
            expect(await room.currentStatus()).to.equal(0);
        });
    });

    describe("Rent Function", function () {
        it("Should allow a user to rent the room", async function () {
            const { room, owner, addr1 } = await loadFixture(deployDAORoomFixture);
            await rentRoom(room, addr1);
        });

        it("Should update the Status to 'Occupied' when it is rented", async function () {
            const { room, owner, addr1 } = await loadFixture(deployDAORoomFixture);
            await rentRoom(room, addr1);
            expect(await room.currentStatus()).to.equal(1);
        });

        it("Should emit 'Occupied' event when it is rented", async function () {
            const { room, owner, addr1 } = await loadFixture(deployDAORoomFixture);

            const cost = ethers.parseUnits("1", "wei");
            await expect(room.connect(addr1).rent({ value: cost }))
                .to.emit(room, "Occupied").withArgs(addr1.address);
        });

        it("Should fail to rent the room if the cost is incorrect", async function () {
            const { room, owner, addr1 } = await loadFixture(deployDAORoomFixture);

            await expect(
                room.connect(addr1).rent()
            ).to.be.revertedWith("Payment of exactly 1 wei is required");

            const cost1 = ethers.parseUnits("0", "wei");
            await expect(
                room.connect(addr1).rent({ value: cost1 })
            ).to.be.revertedWith("Payment of exactly 1 wei is required");

            const cost2 = ethers.parseUnits("2", "wei");
            await expect(
                room.connect(addr1).rent({ value: cost2 })
            ).to.be.revertedWith("Payment of exactly 1 wei is required");
        });

        it("Should update balances of the Owner and Renter", async function () {
            const { room, owner, addr1 } = await loadFixture(deployDAORoomFixture);

            // Get the initial balances of Renter and Owner
            const initialRenterBalance = await ethers.provider.getBalance(addr1.address);
            const initialOwnerBalance = await ethers.provider.getBalance(owner.address);

            // Rent room, calculate the amount of Eth spent on gas
            const { receipt, cost } = await rentRoom(room, addr1);
            const gasSpent = receipt.gasUsed * receipt.gasPrice;

            // Get the updated balances of Renter and Owner
            const updatedRenterBalance = await ethers.provider.getBalance(addr1.address);
            const updatedOwnerBalance = await ethers.provider.getBalance(owner.address);

            // Perform assertions to check the balance changes
            expect(updatedRenterBalance).to.equal(initialRenterBalance - cost - gasSpent);
            expect(updatedOwnerBalance).to.equal(initialOwnerBalance + cost);
        });
    });
});