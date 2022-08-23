pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./IERC20.sol";
import "./IERC3156FlashBorrower.sol";
import "./IERC3156FlashLender.sol";

contract Borrower is IERC3156FlashBorrower , Ownable{
    IERC3156FlashLender pool;
    event loanReceived(address tokenAddress , uint256 amount);
    constructor(address poolAddress) Ownable(){
        pool = IERC3156FlashLender(_poolAddress);
    }

 
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external override returns (bytes32){
        require(initiator==owner(), "You did not reques this loan");
        require(IERC20(token).balanceOf(address(this))==amount, 
        "Error : Didnt receive the loan");

        // do stuff with the funds

        // pay back
        require(IERC20(token).transfer(msg.sender, amount) , "Transfer of token failed");

        return keccak256("IERC3156FlashBorrower.onFlashLoan");
        emit loanReceived(token, _amount);
    }

  

    function executeFlashLoan(address token , uint256 amount , bytes data) external onlyOwner{
        pool.flashLoan(address(this) , token , amount , data);
    }


}
