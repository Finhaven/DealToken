pragma solidity ^0.4.19;

import './PhaseValidator.sol';

/*
  Asynchronous close validtor

          -3M         0M                          60M
           |==========|============================|
Prehistory | Mintable |         Tradeable          | Inactive
           |==========|============================|
           |          |                            |
     Alice | x ---------- x+4M                     |
           |Mint   Hold   Trade                    |
           |          |                            |
       Bob |   x ---------- x+4M                   |
           |  Mint   Hold   Trade                  |
           |          |                            |
     Carol |      x ---------- x+4M                |
           |     Mint |  Hold   Trade              |
           |          |                            |

 */
contract AsyncCloseValidator is TokenValidator {
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
        uint256 _amount
    ) public returns (byte _validation) {
      return (_deal == _from) ? mintable(_deal) : transferrable(_deal, _from, _amount);
    }

    // HELPERS //

    function mintable(Deal _deal) internal pure returns (byte _validation) {
        if(now < _deal.startTime) { return hex"43"; } // Not yet available
        if(now >= _deal.endTime) { return hex"40"; } // Expired
        return hex"41"; // Available
    }

    function transferrable(Deal _deal, address _from, uint256 _amount) internal pure returns (byte _validation) {
        if(now < _deal.endTime) { return hex"43"; } // Not yet available
        if(now < _deal.mintedAt[_from] + _deal.holdPeriod) { return hex"43"; }

        // Which of these? 🤔
        // mapping(address _user => [mintTime, uint256][])
        // mapping(address _user => [mintTime, balance])

        return hex"41";
    }

    /* mapping (address => uint) accountBalances; */
    /* mapping (uint => address) accountIndex; */
    /* uint accountCount; */
    /* function iterateAccountsBalances() */
    /* { */
    /*   for(uint i=0;i<accountCount;i++) */
    /*     { */
    /*       doSomeStuff(accountBalances[accountIndex[i]]); */
    /*     } */
    /* } */
}
