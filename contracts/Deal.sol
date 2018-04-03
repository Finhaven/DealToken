pragma solidity ^0.4.19;

import '../node_modules/validated-token/contracts/ReferenceToken.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol';

contract Deal is ReferenceToken {
    using SafeMath for uint256;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public holdPeriod;

    // Does this need to be mapping(address => TokenTimelock[])?
    mapping(address => TokenTimelock) public holds;

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
      holdPeriod = _holdPeriod;
    }

    function mint(address _tokenHolder, uint256 _amount) public onlyOwner whileOpen {
        TokenTimelock escrow = new TokenTimelock(ERC20Basic(this), _tokenHolder, now.add(holdPeriod));
        holds[_tokenHolder] = escrow;
        super.mint(escrow, _amount);
    }

    /// Releases hold on funds from TokenTimelock. Reverts if the hold time has not elapsed.
    function releaseFor(address _tokenHolder) public { holds[_tokenHolder].release(); }
    // Not removing from map saves gas: https://ethereum.stackexchange.com/questions/41576/is-it-cheaper-to-delete-or-ignore-obsolete-mappings
    // Do we need to check if the TokenTimelock is there before calling #release/0?

    /// Reverts if not in crowdsale time range.
    modifier whileOpen {
        require(now >= startTime);
        require(now <= endTime);
        _;
    }
}
