pragma solidity ^0.4.21;

import "../../contracts/Range.sol";

contract RangeMock {
    using Range for uint256;

    function RangeMock() public {}

    function test(uint256 a, uint256 b, uint256 c) public pure returns (bool) {
      return a.isBetween(b, c);
    }
}
