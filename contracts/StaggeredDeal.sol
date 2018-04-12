pragma solidity ^0.4.19;
/* pragma experimental ABIEncoderV2; */

import "./Deal.sol";
import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

/** Staggered close

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
contract StaggeredDeal is Deal, Ownable {
    using SafeMath for uint256;

    struct Minting {
      uint256 amount;
      uint256 createdAt;
    }

    // Indexed from 1, blugh
    uint public holderCount;
    mapping(uint => address) internal holderIndex;
    mapping(address => uint) internal reverseHolderIndex;

    mapping(address => Minting[]) internal mintHistory;

    function StaggeredDeal(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _holdPeriod,
        TokenValidator _validator
    ) Deal(_name, _symbol, _granularity, _startTime, _endTime, _holdPeriod, _validator) public {}

    function mint(address _tokenHolder, uint256 _amount) public {
        super.mint(_tokenHolder, _amount);
        upsertHolder(_tokenHolder);

        mintHistory[_tokenHolder].push(Minting({
            amount: _amount,
            createdAt: now
        }));
    }

    function upsertHolder(address _tokenHolder) internal {
        if (reverseHolderIndex[_tokenHolder] == 0) {
            holderCount++;
            holderIndex[holderCount] = _tokenHolder;
            reverseHolderIndex[_tokenHolder] = holderCount;
        }
    }

    function isEnoughSpendable(address _from, uint256 _amount) internal view returns (bool) {
        return spendableAmount(_from) >= _amount;
    }

    function spendableAmount(address _holder) internal view returns (uint256) {
        uint256 total = 0;

        for (uint i = 0; i < mintHistory[_holder].length; i++) {
            if (now < mintHistory[_holder][i].createdAt.add(holdPeriod)) {
                total.add(mintHistory[_holder][i].amount);
            }
        }

        return total;
    }
}
