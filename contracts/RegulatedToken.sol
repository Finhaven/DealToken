pragma solidity ^0.4.15;


import '../../node_modules/zeppelin-solidity/contracts/token/MintableToken.sol';
import '../../node_modules/zeppelin-solidity/contracts/token/LimitedTransferToken.sol';


contract RegulatedToken is MintableToken, LimitedTransferToken {

  mapping (address => bool) authorizedAddresses;

  event Authorization(address indexed _sender, address indexed _authorized, bool _isAuthorized);

  event CheckAuthorization(address indexed _authorized, bool _isAuthorized);

  event TransferFrom(address _from, address _to, uint256 _value);

  event IsAuthorized(address indexed _authorized);

  modifier onlyAuthorized(address _to) {
    CheckAuthorization(_to, authorizedAddresses[_to]);
    require(authorizedAddresses[_to]);
    _;
  }

  function authorizeAddress(address _authorized, bool _isAuthorized) onlyOwner public {
    Authorization(msg.sender, _authorized, _isAuthorized);
    authorizedAddresses[_authorized] = _isAuthorized;
  }

  function isAuthorized(address _authorized) public returns (bool){
    IsAuthorized(_authorized);
    return authorizedAddresses[_authorized];
  }

  function transferFrom(address _from, address _to, uint256 _value) onlyAuthorized(_to) public returns (bool) {
    TransferFrom(_from, _to, _value);
    return super.transferFrom(_from, _to, _value);
  }

  function mint(address _to, uint256 _amount)
    //  onlyOwner
    //  canMint
  onlyAuthorized(_to)
  public returns (bool) {
    return super.mint(_to, _amount);
  }
}
