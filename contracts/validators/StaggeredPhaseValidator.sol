pragma solidity ^0.4.19;
pragma experimental ABIEncoderV2;

import "./PhaseValidator.sol";
import "../StaggeredDeal.sol";
import "../MintHistory.sol";

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
    function checkTransfer(
        StaggeredDeal _deal,
        address _from,
        address _to,
        uint256 _amount
    ) public view returns (byte _validation) {
        if (_from == address(0)) {
            return canMint(_deal);
        } else {
            return canTransfer(_deal, _from, _amount);
        }
    }

    // HELPERS //

    function canMint(StaggeredDeal _deal) internal pure returns (byte _validation) {
        if(now < _deal.startTime()) { return hex"43"; } // Not yet available
        if(now >= _deal.endTime()) { return hex"40"; } // No longer available
        return hex"41"; // Available
    }

    function canTransfer(
        StaggeredDeal _deal,
        address _from,
        uint256 _amount
    ) internal view returns (byte _validation) {
        if (isMintPeriod(_deal) || enoughSpendable(_deal, _from, _amount)) {
            return hex"43";
        } else {
            return hex"41";
        }
    }

    function isMintPeriod(Deal _deal) internal view returns (bool) {
        return now < _deal.endTime();
    }

    function enoughSpendable(
        StaggeredDeal _deal,
        address _from,
        uint256 _amount
    ) internal view returns (bool) {
        uint256 total = _deal.balanceOf(_from);

        /* MintHistory.Minting[] storage foo = _deal.mintHistory(_from); */

        /* for (uint i = 0; i < foo.length; i++) { */
        /*     if (now < _deal.mintHistory(_from)[i].createdAt.add(_deal.holdPeriod())) { */
        /*       total.sub(_deal.mintHistory(_from)[i].amount); */
        /*     } */
        /* } */

        return total >= _amount;
    }
}
