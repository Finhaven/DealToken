pragma solidity ^0.4.19;

import './Deal.sol';
import './TimeValidator.sol';

import '../node_modules/validated-token/contracts/TokenValidator.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';

contract DealValidator is Ownable, TokenValidator {
    using SafeMath for uint256;

    mapping(address => bool) private auths;

    TimeValidator private timeValidator;

    function DealValidator(TimeValidator _timeValidator) Ownable public {
        timeValidator = _timeValidator;
    }

    // CUSTOM //

    function setAuth(address _address, bool _status) public onlyOwner {
        authorizations[_address] = _status;
    }

    // TOKEN VALIDATOR //

    function check(Deal _deal, address _account) public returns(byte _status) {
        // Reads way better with guards. I can add the tnested logic, if preferred.
        if(!auths[_account]) { return hex"10"; } // Unauthorized

        byte timeState = timeValidtor.check(_deal, _account);
        if(isOk(timeState)) { return hex"11"; } // Authorized
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
