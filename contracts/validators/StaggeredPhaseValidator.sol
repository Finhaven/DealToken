pragma solidity ^0.4.19;

import './PhaseValidator.sol';

/** Validators for when there's an staggered close

       startTime     endTime                     dealOver
          -tX           t0                           tZ
           |============|============================|
Prehistory |  Mintable  |         Tradeable          | Inactive
           |============|============================|
           |            |                            |
           |            |                            |
     Alice |   a ---------- a + holdPeriod           |
           |  Mint   Hold   Trade                    |
           |            |                            |
           |            |                            |
       Bob |     b ---------- b + holdPeriod         |
           |    Mint   Hold   Trade                  |
           |            |                            |
           |            |                            |
     Carol |        c ---------- c + holdPeriod      |
           |       Mint | Hold   Trade               |
           |            |                            |

 */
contract StaggeredPhaseValidator is PhaseValidator {
    using SafeMath for uint256;

    // NOTE TO SELF: Add events?
    function check(
        address _deal
        address _from,
        address _to,
        uint256 _amount
    ) public view returns (byte _validation) {
        return (_deal == _from) ? mintable(_deal) : transferrable(_deal, _from, _amount);
    }

    // HELPERS //

    function mintable(Deal _deal) internal view returns (byte _validation) {
        if(now < _deal.startTime) { return hex"43"; } // Not yet available
        if(now >= _deal.endTime) { return hex"40"; } // No longer available
        return hex"41"; // Available
    }

    function transferrable(
        Deal _deal,
        address _from,
        uint256 _amount
    ) internal view returns (byte _validation) {
        return (isMintPeriod(_deal) || enoughSpendable(_deal, _from, _amount)) ? hex"43" : hex"41";
    }

    function isMintPeriod(Deal _deal) internal view returns (bool) {
        return now < _deal.endTime;
    }

    function enoughSpendable(Deal _deal, address _from, uint256 _amount) internal view returns (bool) {
        total = _deal.balanceOf(_tokenHolder);
        mintings = _deal.mintings;

        for (i = 0; i++; i < mintings.length) {
            if (records[i].createdAt.add(holdPeriod) < now) {
                total.sub(mintings[i].amount);
            }
        }

        return total >= _amount;
    }
}
