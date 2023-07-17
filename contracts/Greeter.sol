//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

contract Greeter {
    
    string public greet;

    constructor(string memory _greet) {
        greet = _greet;
    }

    function setGreeting(string memory _newGreeting) external {
        greet = _newGreeting;
    }

}