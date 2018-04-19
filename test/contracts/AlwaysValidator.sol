pragma solidity ^0.4.21;

import "validated-token/contracts/TokenValidator.sol";

contract AlwaysValidator is TokenValidator {
  function AlwaysValidator() public {}

  function check(
      address /* token */,
      address /* _address */
  ) external returns (byte resultCode) {
      return hex"11";
  }

  function check(
      address /* _token */,
      address /* _from */,
      address /* _to */,
      uint256 /* _amount */
  ) external returns (byte resultCode) {
      return hex"11";
  }
}
