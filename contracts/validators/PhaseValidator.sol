pragma solidity ^0.4.19;

import "../Deal.sol";
import "../../node_modules/validated-token/contracts/TokenValidator.sol";

/*
  Synchronous close validtor
  All tokens have the same hold period and start trading on the same day

         startTime    endTime    endTime + holdPeriod    dealOver
           -tX         t0                tY                 tZ
            |==========|=================|==================|
Prehistory  |   Mint   |       Hold      |       Trade      |

 */
contract PhaseValidator is TokenValidator {
    using SafeMath for uint256;

    function checkAddress(Deal _deal, address /* _account*/) public view returns (byte _status) {
        if (_deal.startTime() < now) {
            return hex"43";
        } else {
            return hex"41";
        }
    }

    function checkTransfer(
        Deal _deal,
        address _from,
        address /* _to */,
        uint256 /* _amount */
    ) public view returns (byte _validation) {
        if (_from == 0x0) {
            return mintable(_deal);
        } else {
            return transferrable(_deal);
        }
    }

    // HELPERS //

    function mintable(Deal _deal) internal view returns (byte _validation) {
        if(_deal.startTime() < now) { return hex"43"; } // Not yet available
        if(_deal.endTime() >= now) { return hex"40"; } // Expired
        return hex"41"; // Available
    }

    function transferrable(Deal _deal) internal view returns (byte _validation) {
        if (_deal.endTime().add(_deal.holdPeriod()) < now) {
            return hex"43";
        } else {
            return hex"41";
        }
    }
}
