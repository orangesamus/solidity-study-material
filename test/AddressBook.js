const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Address Book", function () {

    async function deployAddressBookFixture() {
        const AddressBook = await ethers.getContractFactory("AddressBook");
        const [owner, addr1, addr2] = await ethers.getSigners();
        const addressBook = await AddressBook.deploy();
        await addressBook.waitForDeployment();
        return {addressBook, owner, addr1, addr2 };
    }

    it("Should get the length of a string", async function () {
        const { addressBook } = await loadFixture(deployAddressBookFixture);
        
        expect(await addressBook.getStringLength("")).to.equal(0);
        expect(await addressBook.getStringLength("Ben")).to.equal(3);
    });

    it("Should fail to add a new record if the name is blank", async function () {
        const { addressBook, owner, addr1, addr2 } = await loadFixture(deployAddressBookFixture);
        
        await expect(
            addressBook.addAddress("", owner.address, "Empty")
        ).to.be.revertedWith("Name can not be empty");
    });

    it("Should add to and retrieve from a user's Address Book", async function () {
        const { addressBook, owner, addr1, addr2 } = await loadFixture(deployAddressBookFixture);

        await addressBook.addAddress("Bob", owner.address, "This is me");
        await addressBook.addAddress("Caleb", addr1.address, "This is Caleb");
        await addressBook.addAddress("Patrick", addr2.address, "No, this is Patrick!");

        const aBook = await addressBook.getAddrBook();

        expect(aBook[0].name).to.equal("Bob");
        expect(aBook[0].addr).to.equal(owner.address);
        expect(aBook[0].note).to.equal("This is me");

        expect(aBook[1].name).to.equal("Caleb");
        expect(aBook[1].addr).to.equal(addr1.address);
        expect(aBook[1].note).to.equal("This is Caleb");

        expect(aBook[2].name).to.equal("Patrick");
        expect(aBook[2].addr).to.equal(addr2.address);
        expect(aBook[2].note).to.equal("No, this is Patrick!");
    });
});
