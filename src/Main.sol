// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProxyContract {
    address public owner;
    mapping(address => bool) public registeredUsers;
    bool private locked = false;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyRegisteredUser() {
        require(registeredUsers[msg.sender] == true, "Not a registered user");
        _;
    }

    modifier noReentrancy() {
        require(!locked, "Reentrant call detected!");
        locked = true;
        _;
        locked = false;
    }

    event Executed(address target, address caller, bool success);
    event UserRegistered(address user);
    event UserDeregistered(address user);

    constructor() {
        owner = msg.sender;
    }

    function registerUser(address user) public onlyOwner {
        registeredUsers[user] = true;
        emit UserRegistered(user);
    }

    function deregisterUser(address user) public onlyOwner {
        registeredUsers[user] = false;
        emit UserDeregistered(user);
    }

    function execute(address _target, bytes memory _data) public onlyRegisteredUser noReentrancy returns (bool, bytes memory) {
        (bool success, bytes memory result) = _target.call(_data);
        emit Executed(_target, msg.sender, success);
        require(success, "External call failed");
        return (success, result);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}