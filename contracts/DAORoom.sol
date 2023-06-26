//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @author  Pradhumna Pancholi
 * @title   A DAO Room rental
 * @dev     This contract creates logic to rent a DAO room
 * @notice  You can rent a room as long as it is vacant and you pay the cost of 1 wei
 */
contract DAORoom {
    
    /// @notice  Address of the owner of the DAO Room
    address payable public owner;

    /// @notice  The cost to rent a DAO Room
    uint public cost;

    enum Status {Vacant, Occupied}

    Status currentStatus;

    /// @dev  Event to determine when a room becomes occupied and who occupies it
    event Occupied(address _occupant);

    /// @notice  Creater of a DAO Room is the owner, the room is vacant, and costs 1 wei
    constructor() {
        owner =  payable(msg.sender);
        cost = 1;
        currentStatus = Status.Vacant;
    }

    modifier onlyWhenVacant {
        require(currentStatus == Status.Vacant, "Room is occupied");
        _;
    }

    /**
     * @notice  When attempting to rent, the room must be vacant and you must pay 1 wei
     * @dev     The function will emit an Occupied event with the address of the renter
     */
    function rent() external payable onlyWhenVacant {
        require(msg.value != cost, "Insufficient funds");
        owner.transfer(msg.value);
        emit Occupied(msg.sender);
    } 



}