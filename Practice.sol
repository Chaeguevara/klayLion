//Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;

contract Practice{
    uint256 private totalSupply = 10 ;
    string public name = "KlayLion";

    address public owner; //contract deployer
    mapping(uint256 => string) public tokenURIs;

    constructor () public {
        owner = msg.sender;
    }
    function getTotalSupply() public view returns (uint256){
        return totalSupply * 1000000;
    }

    function setTotalSupply(uint256 newSupply) public{
        require(owner == msg.sender, 'Not owner');
        totalSupply = newSupply;
    }
}