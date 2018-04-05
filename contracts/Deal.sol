pragma solidity ^0.4.19;

import '../node_modules/validated-token/contracts/ReferenceToken.sol';

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

      startTime  = _startTime;
      endTime    = _endTime;
    }

    function endNow() public onlyOwner {
        endTime = now;
    }

    // Handle in validator
    /// Reverts if not in crowdsale time range.
    modifier whileOpen {
        require(now >= startTime);
        require(now <= endTime);
        _;
    }

    // ERC20 //

    function mint(address _tokenHolder, uint256 _amount) public onlyOwner whileOpen {
        super.mint(_tokenHolder, _amount);
    }

    function transfer(address _to, uint256 _amount) public whileOpen returns (bool success) {
        super.transfer(_to, _amount);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public whileOpen returns (bool success) {
        super.transferFrom(_from, _to, _amount);
    }
}
