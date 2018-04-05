pragma solidity ^0.4.19;

import './Deal.sol';


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
contract StaggeredDeal is ReferenceToken {
    struct Minting {
        uint256 amount;
        uint256 createdAt;
    }

    mapping(address => Minting[]) public mintings;

    function StaggeredDeal(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _holdPeriod,
        TokenValidator _validator
    ) DealToken(_name, _symbol, _granularity, _holdPeriod, _validator) public {}

    function mint(address _tokenHolder, uint256 _amount) public onlyOwner whileOpen {
        mintings[_tokenHolder].push(Minting({
            amount: _amount,
            createdAt: now
        }));

        super.mint(_tokenHolder, _amount);
    }
}
