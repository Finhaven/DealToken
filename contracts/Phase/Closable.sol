pragma solidity ^0.4.21;

contract Closable {
    uint256 public closingTime;

    constructor(uint256 _closingTime) public {
        require(_closingTime >= now);
        closingTime = _closingTime;
    }

    function isClosed() public view returns (bool) {
        return now >= closingTime;
    }
}
