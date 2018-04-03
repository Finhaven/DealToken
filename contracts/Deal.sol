pragma solidity ^0.4.15;

import '../node_modules/validated-token/contracts/ReferenceToken.sol';
import '../node_modules/zepplin-solidity/contracts/token/ERC20/TokenTimelock.sol';

contract Deal is ReferenceToken, TokenTimelock {
  function Deal(
      string         _name,
      string         _symbol,
      uint256        _granularity,
      TokenValidator _validator
  ) public {
    ReferenceToken(_name, _symbol, _granularity, _validator);
  }

  function mint(address _tokenHolder, uint256 _amount) public onlyOwner {
    escrow = TokenTimelock(this, _tokenHolder, now + 16 weeks);
    super.mint(escrow, _amount);
  }
}
