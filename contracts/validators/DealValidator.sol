pragma solidity ^0.4.19;

import "../Deal.sol";
import "./PhaseValidator.sol";

import "../../node_modules/validated-token/contracts/TokenValidator.sol";
import "../../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

/*
   Deal          DealValidator        PhaseValidator
    |                 |                    |
    |    check/4      |                    |
    +---------------> |                    |
    |                 |     check/4        |
    |                 +------------------> |
    |                 |                    |
    |                 |                    |
    |                 |    startTime/0     |
    | <------------------------------------+
    |                 |    12345           |
    +------------------------------------> |
    |                 |                    |
    |                 |                    |
    |                 |      endTime/0     |
    | <------------------------------------+
    |                 |    67890           |
    +------------------------------------> |
    |                 |                    |
    |                 |                    |
    |                 |       hex"41"      |
    |                 | <------------------+
    |      hex"41"    |                    |
    | <---------------+                    |
    |                 |                    |
    |                 |                    |
 */
contract DealValidator is Ownable, TokenValidator {
    using SafeMath for uint256;

    PhaseValidator private phaseValidator;
    mapping(address => bool) private auths;

    function DealValidator(PhaseValidator _phaseValidator) Ownable public {
        phaseValidator = _phaseValidator;
    }

    function setAuth(address _address, bool _status) public onlyOwner {
        auths[_address] = _status;
    }

    // TOKEN VALIDATOR //

    function check(Deal _deal, address _account) public returns(byte _status) {
        if (auths[_account]) {
            return phaseCheck(_deal, _account);
        } else {
            return hex"10";
        }
    }

    function check(
        address /* _token */,
        address _from,
        address _to,
        uint256 _amount
    ) public returns (byte _validation) {
        if (auths[_from] && auths[_to]) {
            return hex"11";
        } else {
            return hex"10";
        }
    }

    // HELPERS //

    function phaseCheck(Deal _deal, address _tokenHolder) internal view returns (byte _validation) {
        byte phaseState = phaseValidator.check(_deal, _tokenHolder);

        if (isOk(phaseState)) {
            return hex"11";
        } else {
            return phaseState;
        }
    }

    function isOk(byte status) internal view returns (bool) {
        return (status & hex"0F") == 1;
    }
}
