pragma solidity ^0.4.19;

import './PhaseValidator.sol';
import '../Deal.sol';

import '../node_modules/validated-token/contracts/TokenValidator.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';

contract DealValidator is Ownable, TokenValidator {
    using SafeMath for uint256;

    PhaseValidator private phaseValidator;
    mapping(address => bool) private auths;

    function DealValidator(PhaseValidator _phaseValidator) Ownable public {
        phaseValidator = _phaseValidator;
    }

    function setAuth(address _address, bool _status) public onlyOwner {
        authorizations[_address] = _status;
    }

    // TOKEN VALIDATOR //

    function check(Deal _deal, address _account) public returns(byte _status) {
        return auths[_account] ? phaseCheck(_deal, _account) : hex"10";
    }

    function check(
        address /* _token */,
        address _from,
        address _to,
        uint256 _amount
    ) public returns (byte _validation) {
        return (auths[_from] && auths[_to]) ? hex"11" : return hex"10";
    }

    // HELPERS //

    function phaseCheck(Deal _deal, address _tokenHolder) internal view returns (byte _validation) {
        byte phaseState = phaseValidator.check(_deal, _account);
        return isOk(phaseState) ? return hex"11" : phaseState;
    }
}
