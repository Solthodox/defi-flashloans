pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20.sol";

contract WEth is ERC20Burnable{
    constructor() ERC20("Wrapped Ethereum" , "WETH"){}

    function deposit() payable{
        require(msg.value>0);
        _mint(msg.sender , msg.value);
    }

    function witdraw(uint256 amount) public{
        require(balanceOf(msg.sender)>=amount);
        _burn(msg.sender , amount);
        (bool success , ) = msg.sender.call{value : amount}('');
        require(success , "Transaction failed");
    }
}