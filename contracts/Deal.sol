pragma solidity ^0.4.19;

import '../node_modules/validated-token/contracts/ReferenceToken.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol';

contract Deal is ReferenceToken {
    using SafeMath for uint256;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public holdPeriod;


    // If and when we move to timestamped issuance
    /* struct Balance { */
    /*   uint256 mintedAt; */
    /*   uint256 value; */
    /* } */

    /* mapping(address => Balance[]) private mBalances; */

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

    // CUSTOM //

    function endNow() public onlyOwner {
        endTime = now;
    }

    // MODIFERS //

    /// Reverts if not in crowdsale time range.
    modifier whileOpen {
        require(now >= startTime);
        require(now <= endTime);
        _;
    }

    // ERC20 //

    function mint(address _tokenHolder, uint256 _amount) public onlyOwner whileOpen {
        super.mint(_tokenHolder, _amount)
    }

    function transfer(address _to, uint256 _amount) public whileOpen returns (bool success) {
        super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint256 _amount) public whileOpen returns (bool success) {
        super.transferFrom(_from, _to, _amount);
    }

    // HELPERS //

    /* function check(address _tokenHolder) internal returns (uint8) { */
    /*     validator.check(this, _tokenHolder); */
    /* } */

    /* function check(address _from, address _to, uint256 _amount) internal returns (uint8) { */
    /*     validator.check(this, _from, _to, _amount); */
    /* } */
}
