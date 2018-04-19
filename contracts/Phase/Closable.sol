pragma solidity ^0.4.21;

contract Closable {
    uint256 public closingTime;

    function Closable(uint256 _closingTime) public {
        closingTime = _closingTime;
    }

    function isClosed() public view returns (bool) {
        return now >= closingTime;
    }
}
