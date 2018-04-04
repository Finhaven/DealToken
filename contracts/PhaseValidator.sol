pragma solidity ^0.4.19;

import './Deal.sol';
import '../node_modules/validated-token/contracts/TokenValidator.sol';

/*
  Synchronous close validtor
  All tokens have the same hold period and start trading on the same day


           -3M         0M           4M               60M
            |----------|------------|----------------|
Prehistory  |   Mint   |   Hold     |     Trade      |

 */
contract SyncCloseValidator is TokenValidator {
    using SafeMath for uint256;

    // VALIDATION //

    // Ready?
    function check(Deal _deal, address /* _account */) public pure returns (byte _status) {
        return (_deal.startTime < now) ? hex"43" : hex"41";
    }

    function check(
        address _deal
        address _from,
        address _to,
        uint256 /* _amount */
    ) public returns (byte _validation) {
        return (_deal == _from) ? mintable(_deal) : transferrable(_deal);
    }

    // HELPERS //

    function mintable(Deal _deal) internal pure returns (byte _validation) {
        if(_deal.startTime < now) { return hex"43"; } // Not yet available
        if(_deal.endTime  >= now) { return hex"40"; } // Expired
        return hex"41"; // Available
    }

    function transferrable(Deal _deal) internal pure returns (byte _validation) {
        return (_deal.endTime + _deal.holdPeriod < now) ? hex"43" : hex"41";
    }
}
