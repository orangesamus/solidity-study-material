//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @author  .
 * @title   .
 * @dev     .
 * @notice  .
 */
contract DAORoom {
    
    /// public state variable comment
    address payable public owner;

    /// public state variable comment
    uint public cost;

    enum Status {Vacant, Occupied}

    Status currentStatus;

    /// event comment
    event Occupied(address _occupant);

    /// constructor comment
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
     * @notice  .
     * @dev     .
     */
    function rent() external payable onlyWhenVacant {
        require(msg.value != cost, "Insufficient funds");
        owner.transfer(msg.value);
        emit Occupied(msg.sender);
    } 



}