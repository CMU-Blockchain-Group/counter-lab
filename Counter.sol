pragma solidity ^0.6.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
contract Counter is Ownable {
    /* Define counter of type integer */
    int counter;

    /* This runs when the contract is executed */
    constructor() public {
       counter = 0;
    }

    /* Resets counter to zero. Only callable by the creator of the contract */
    function reset() public onlyOwner{
        counter = 0;
    }
    
    /* Simple function to add 1 to the counter */
    function add() public {
        counter += 1;
    }
    
    /* Returns the counter. Does not cost gas. */
    function getCounter() public view returns (int) {
        return counter;
    }
}