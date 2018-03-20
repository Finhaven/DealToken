
 pragma solidity ^0.4.15;

import "./RegulatedToken.sol";

contract DealToken is RegulatedToken {
  string public name = "Frontier Deal Token";
  string public symbol = "FRDT";
  uint256 public decimals = 18;
  address deal;
  function DealToken() public {
  }
}
