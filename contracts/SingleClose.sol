pragma solidity ^0.4.19;

import './Deal.sol';

import '../node_modules/validated-token/contracts/ReferenceToken.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol';

contract SingleClose is Deal {
    using SafeMath for uint256;

    uint256 public holdPeriod;

    // Hash all addresses?
    // Does this need to be mapping(address => TokenTimelock[])?
    mapping(address => TokenTimelock) public holds;

    function SingleClose(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _holdPeriod,
        TokenValidator _validator
    ) Deal(_name, _symbol, _granularity, _startTime, _endTime, _validator) public {
        holdPeriod = _holdPeriod;
    }
}
