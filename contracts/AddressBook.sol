//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @author  Pradhumna Pancholi
 * @title   A simple Address Book
 * @dev     This contract is just used for experimentation
 */
contract AddressBook {

    //struct for a type of "address" // this allows every user to have their address book//
    struct Record {
        string name;
        address addr;
        string note;
    }

    /**
     * @dev  mapping to link user with their addressbook
     */
    mapping (address => Record[]) private _aBook;

    /**
     * @notice  Calculates and returns the length of a string in number of bytes
     * @param   _str  The input string
     * @return  uint256  The length of the input string in number of bytes
     */
    function getStringLength(string memory _str) public pure returns (uint256){
        bytes memory bts = bytes(_str);
        return bts.length;
    }
    
    /**
     * @notice  Add a new record to the user's address book
     * @param   _name  Name associated with the address. Must have at least one character
     * @param   _addr  Address to be added
     * @param   _note  Any additional notes or comments for the address
     */
    function addAddress(string memory _name, address _addr,string memory _note) public   {
        require(getStringLength(_name) >= 1, "Name can not be empty");
        Record memory newRecord = Record(_name, _addr, _note);
        _aBook[msg.sender].push(newRecord);
    }
    
    /**
     * @notice  Get the user's address book
     * @return  Record[] The address book
     */
    function getAddrBook() public view returns (Record[] memory){
        return _aBook[msg.sender];
    }

}