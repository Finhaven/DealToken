pragma solidity ^0.4.21;

import "../../contracts/DealValidator.sol";

contract ExtendedDealValidator is DealValidator {
    function ExtendedDealValidator() DealValidator public {}

    function check2(address _deal, address _account) external returns (byte) {
        return this.check(_deal, _account);
    }

    function check4(
        address _token,
        address _from,
        address _to,
        uint256 _amount
    ) external returns (byte) {
        return this.check(_token, _from, _to, _amount);
    }
}
