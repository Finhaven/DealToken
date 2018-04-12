pragma solidity ^0.4.19;

import "../node_modules/validated-token/contracts/ReferenceToken.sol";

contract Deal is ReferenceToken {
    using SafeMath for uint256;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public holdPeriod;

    function Deal(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _holdPeriod,
        TokenValidator _validator
    ) ReferenceToken(_name, _symbol, _granularity, _validator) public {
        require(_startTime >= now);
        require(_startTime < _endTime);

        holdPeriod = _holdPeriod;
        startTime  = _startTime;
        endTime    = _endTime;
    }

    function endNow() public onlyOwner {
        endTime = now;
    }
}
