pragma solidity ^0.4.21;

import "./Range.sol";

contract PhasedToken {
    using Range for uint256;

    uint256 public mintStartTime;
    uint256 public holdStartTime;
    uint256 public transferStartTime;

    function PhasedToken(
        uint256 _mintStartTime,
        uint256 _holdStartTime,
        uint256 _transferStartTime
    ) public {
        require(now <= _mintStartTime);
        require(_mintStartTime < _holdStartTime);
        require(_holdStartTime < _transferStartTime);

        mintStartTime  = _mintStartTime;
        holdStartTime  = _holdStartTime;
        transferStartTime  = _transferStartTime;
    }

    function isBeforeMintPhase() public view returns (bool) {
        return now < mintStartTime;
    }

    function isMintPhase() public view returns (bool) {
        return now.isBetween(mintStartTime, holdStartTime);
    }

    function isHoldPhase() public view returns (bool) {
        return now.isBetween(holdStartTime, transferStartTime);
    }

    function isTransferPhase() public view returns (bool) {
        return now >= transferStartTime;
    }
}
