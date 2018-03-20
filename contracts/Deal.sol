pragma solidity ^0.4.15;


import '../../node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import './TxOwnable.sol';
import './DealToken.sol';


contract Deal is Crowdsale, TxOwnable {

  DealToken dealToken;
  mapping (address => bool) authorized;
  event Authorizing(address sender, address investor);

  function Deal(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)
   Crowdsale(_startTime, _endTime, _rate, _wallet) TxOwnable {
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
//    address dealAddress = address(this);
//    DealToken(dealAddress, address(token));
    dealToken = new DealToken();
    return dealToken;
  }

  function authorize(address investor) onlyOwner public {
    Authorizing(msg.sender,investor);
    dealToken.authorizeAddress(investor,true);
    authorized[investor] = true;
  }


  function buyTokens(address beneficiary) public payable {
    return super.buyTokens(beneficiary);
  }
}
