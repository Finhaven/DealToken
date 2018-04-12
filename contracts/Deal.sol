pragma solidity ^0.4.19;

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

    function mint(address _tokenHolder, uint256 _amount) public onlyOwner {
        require(isMintPhase());
        return super.mint(_tokenHolder, _amount);
    }

    function approve(address _spender, uint256 _amount) public returns (bool success) {
        require(canTransfer(msg.sender, _spender, _amount));
        return super.approve(_spender, _amount);
    }

    function transfer(address _to, uint256 _amount) public returns (bool success) {
        canTransfer(0x0, _to, _amount);
        return super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        canTransfer(_from, _to, _amount);
        return super.transferFrom(_from, _to, _amount);
    }

    // HELPERS //

    function canTransfer(address _from, address _to, uint256 _amount) internal returns (bool) {
        return isTransferPhase() && isOk(validate(_from, _to, _amount));
    }

    function endNow() public onlyOwner {
        endTime = now;
    }

    function isMintPhase() internal view returns (bool) {
        return (startTime >= now && now < endTime);
    }

    function isTransferPhase() internal view returns (bool) {
        return endTime.add(holdPeriod) >= now;
    }

    // Validation Helpers

    function validate(address _user) private returns (byte) {
        byte checkResult = validator.check(this, _user);
        emit Validation(checkResult, _user);
        return checkResult;
    }

    function validate(
        address _from,
        address _to,
        uint256 _amount
    ) private returns (byte) { // SWITCH TO INTERNAL
        byte checkResult = validator.check(this, _from, _to, _amount);
        emit Validation(checkResult, _from, _to, _amount);
        return checkResult;
    }
}
