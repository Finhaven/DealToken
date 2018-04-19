pragma solidity ^0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./PhasedToken.sol";

contract AdvancableToken is Ownable, PhasedToken {
    function AdvancableToken(
        uint256 _mintStartTime,
        uint256 _holdStartTime,
        uint256 _transferStartTime
    ) PhasedToken(_mintStartTime, _holdStartTime, _transferStartTime) public {}

    function startMintPhase() external onlyOwner {
        require(now < mintStartTime);
        mintStartTime = now;
    }

    function startHoldPhase() external onlyOwner {
        require(isMintPhase());
        holdStartTime = now;
    }

    function startTransferPhase() external onlyOwner {
        require(isHoldPhase());
        transferStartTime = now;
    }
}
