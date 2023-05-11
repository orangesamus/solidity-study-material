//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @author  .
 * @title   .
 * @dev     .
 * @notice  .
 */
contract AddressBook {

    //struct for a type of "address" // this allows every user to have their address book//
    struct Record {
        string name;
        address addr;
        string note;
    }

    //mapping to link user with their addressbook//
    mapping (address => Record[]) private _aBook;

    /**
     * @notice  .
     * @dev     .
     * @param   _str  .
     * @return  uint256  .
     */
    function getStringLength(string memory _str) public pure returns (uint256){
        bytes memory bts = bytes(_str);
        return bts.length;
    }
    
    //function to add an address//
    /**
     * @notice  .
     * @dev     .
     * @param   _name  .
     * @param   _addr  .
     * @param   _note  .
     */
    function addAddress(string memory _name, address _addr,string memory _note) public   {
        require(getStringLength(_name) >= 1, "Name can not be empty");
        Record memory newRecord = Record(_name, _addr, _note);
        _aBook[msg.sender].push(newRecord);
    }
    
    //function to get a user's addeess book//
    /**
     * @notice  .
     * @dev     .
     * @return  .
     */
    function getAddrBook() public view returns (Record[] memory){
        return _aBook[msg.sender];
    }

}