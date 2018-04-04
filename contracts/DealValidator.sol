pragma solidity ^0.4.19;

import './Deal.sol';
import '../node_modules/validated-token/contracts/TokenValidator.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';

contract DealValidator is Ownable, TokenValidator {
    using SafeMath for uint256;

    mapping(address => bool) private auths;

    function DealValidator() Ownable public {}

    // CUSTOM //

    function setAuth(address _address, bool _status) public onlyOwner {
        authorizations[_address] = _status;
    }

    function availability(Deal _token) internal pure returns (byte _status) {
      if(_token.startTime < now) {
          return hex"43"; // Not yet available
      }

      if(_token.endTime >= now) {
          return hex"40"; // Expired
      }

      return hex"41"; // Available
    }

    // TOKEN VALIDATOR //

    function check(Deal _deal, address _account) public returns(byte _status) {
        // Reads way better with guards. I can add the tnested logic, if preferred.
        if(!auths[_account]) { return hex"10"; } // Unauthorized

        byte timeState = availability(_deal);
        if(timeState == hex"41") { return hex"11"; } // Authorized
        return timeState; // Pass along time failure code
    }

    function check(
        address /* _tokem */,
        address _from,
        address _to,
        uint256 _amount
    ) public returns (uint8 result) {
        if(auths[_from] && auths[_to]) {
          return 1;
        } else {
          return 0;
        }
    }
}
