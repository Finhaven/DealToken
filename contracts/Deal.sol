pragma solidity ^0.4.21;

import "validated-token/contracts/ReferenceToken.sol";
import "./Phase/PhasedToken.sol";

contract Deal is PhasedToken, ReferenceToken {
    function Deal(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _mintStartTime,
        uint256 _holdStartTime,
        uint256 _transferStartTime,
        TokenValidator _validator
    ) ReferenceToken(_name, _symbol, _granularity, _validator)
      PhasedToken(_mintStartTime, _holdStartTime, _transferStartTime)
      public {}

    function mint(address _tokenHolder, uint256 _amount) public onlyOwner {
        require(isMintPhase());
        return super.mint(_tokenHolder, _amount);
    }

    function canTransfer(
        address _from,
        address _to,
        uint256 _amount
    ) internal returns (bool) {
        return (isTransferPhase() && super.canTransfer(_from, _to, _amount));
    }
}
