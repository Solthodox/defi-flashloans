pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "./IERC3156FlashLender";
import "./IERC20.sol";
import "./IERC3156FlashBorrower.sol";

contract LendingPool is IERC315FlashLender  , Ownable{
    mapping(address => uint256) private  _maxBorrowPercentage;
    mapping(address => uint256) private  _lendingFees;
   
    function addAsset(address token , uint amount ,uint _maxBorrowPercentage , uint _lendingFees) public onlyOwner{
        require(IERC20(token).transferFrom(msg.sender, address(this), amount));

    }
    function maxFlashLoan(address token) external override view returns (uint256){
        uint256 maxLoan = _maxBorrowPercentage[token];
    }

    
    function flashFee(address token, uint256 amount) external override view returns (uint256){
        require(amount<=maxFlashLoan(token), "The amount exceeds the maximum allowed");
        return (amount * _lendingFees[token] / 100);
    }

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool){
        require(amount<=maxFlashLoan(token));
        uint256 fee = amount * _lendingFees / 100;
        uint256 balanceBefore = IERC20(token).balanceOf(address(this));
        require(IERC3156FlashBorrower(receiver).onFlashLoan(tx.origin, token, amount, fee, data)==keccak256("IERC3156FlashBorrower.onFlashLoan")
        , "The recipient contract doesnt match with the IERC3156FlashBorrower standard ");
        uint256 balanceAfter = IERC20(token).balanceOf(address(this));
        require(balanceAfter >= balanceBefore + flashFee(token , amount) ,  "You didnt pay back");
    }
}