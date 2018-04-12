pragma solidity ^0.4.21;

import "../node_modules/validated-token/contracts/ReferenceToken.sol";

contract Deal is ReferenceToken {
    using SafeMath for uint256;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public holdPeriod;

    TokenValidator private validator;

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

    function mint(address _tokenHolder, uint256 _amount) external onlyOwner {
        require(isMintPhase());
        return this.mint(_tokenHolder, _amount);
    }

    function approve(address _spender, uint256 _amount) external returns (bool success) {
        require(isTransferPhase());
        return this.approve(_spender, _amount);
    }

    // HELPERS //

    function endNow() public onlyOwner {
        endTime = now;
    }

    // Phases //

    function isMintPhase() internal view returns (bool) {
        return (startTime >= now && now < endTime);
    }

    function isTransferPhase() internal view returns (bool) {
        return endTime.add(holdPeriod) >= now;
    }
}
