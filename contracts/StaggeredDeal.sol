pragma solidity ^0.4.19;
pragma experimental ABIEncoderV2;

import "./Deal.sol";
import "./MintHistory.sol";

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
contract StaggeredDeal is Deal {
    // Indexed from 1, blugh
    uint public holderCount;
    mapping(uint => address) private holderIndex;
    mapping(address => uint) private reverseHolderIndex;

    mapping(address => MintHistory.Minting[]) private mMintHistory;

    /* function StaggeredDeal( */
    /*     string _name, */
    /*     string _symbol, */
    /*     uint256 _granularity, */
    /*     uint256 _startTime, */
    /*     uint256 _endTime, */
    /*     uint256 _holdPeriod, */
    /*     TokenValidator _validator */
    /* ) Deal(_name, _symbol, _granularity, _holdPeriod, _validator) public {} */

    function mint(address _tokenHolder, uint256 _amount) public onlyOwner {
        super.mint(_tokenHolder, _amount);
        recordMinting(_tokenHolder, _amount);
    }

    function mintHistory(address _holder) public returns (MintHistory.Minting[]) {
        return mMintHistory[_holder];
    }

    function recordMinting(address _tokenHolder, uint256 _amount) internal onlyOwner {
        upsertHolder(_tokenHolder);

        mMintHistory[_tokenHolder].push(MintHistory.Minting({
            amount: _amount,
            createdAt: now
        }));
    }

    function upsertHolder(address _tokenHolder) internal onlyOwner {
        if (reverseHolderIndex[_tokenHolder] == 0) {
            holderCount++;
            holderIndex[holderCount] = _tokenHolder;
            reverseHolderIndex[_tokenHolder] = holderCount;
        }
    }
}
