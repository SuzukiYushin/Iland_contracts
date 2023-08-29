// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
contract Greeter {
address owner;
string private _greeting = "Hello, World!";
constructor() {
owner = msg.sender;
}
    function setGreeting(string memory newGreeting) public {
        require(msg.sender == owner,"Greeter: caller is not the owner");
        _greeting = newGreeting;
    }
    
    function greeting() public view returns(string memory) {
        return _greeting;
    }
}