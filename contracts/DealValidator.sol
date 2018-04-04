pragma solidity ^0.4.19;

import '../node_modules/validated-token/contracts/TokenValidator.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';

contract DealValidator is Ownable, TokenValidator {
    using SafeMath for uint256;

    mapping(address => bool) private authorizations;

    function DealValidator() Ownable public {

    }

    // TokenValidator

    function check(address _token, address _account) public returns(uint8 result) {
        if(authorizations[_account]) {
            return 1;
        } else {
            return 0;
        }
    }

    function check(
        address /* _tokem */,
        address _from,
        address _to,
        uint256 _amount
    ) public returns (uint8 result) {
        if(!authorizations[_from] && authorizations[_to]) {
          return 1;
        } else {
          return 0;
        }
    }

    // Specific

    function setAuthorization(address /* _token */, bool _status) public onlyOwner {
        authorizations[_address] = _status;
    }
}
