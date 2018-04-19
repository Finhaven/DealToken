pragma solidity ^0.4.21;

import "validated-token/contracts/ReferenceToken.sol";
import "./PhasedToken.sol";
import "./Range.sol";

/*
  LIFECYCLE
  =========

  |-----------|--------------------|----------------|
     Minting        Hold Period         Transfer
 */

contract Deal is ReferenceToken, PhasedToken {
    using SafeMath for uint256;

    TokenValidator private validator;

    function Deal(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _mintStartTime,
        uint256 _holdStartTime,
        uint256 _transferStartTime,
        TokenValidator _validator
    ) ReferenceToken(_name, _symbol, _granularity, _validator)
      PhasedToken(_mintStartTime, _holdStartTime, _transferStartTime)
      public {}

    function mint(address _tokenHolder, uint256 _amount) public onlyOwner {
        require(isMintPhase());
        return super.mint(_tokenHolder, _amount);
    }

    function approve(address _spender, uint256 _amount) public returns (bool success) {
        require(isTransferPhase());
        return super.approve(_spender, _amount);
    }
}
