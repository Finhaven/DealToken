pragma solidity ^0.4.15;

import './Deal.sol';

contract DealFactory {
    event DealCreated(address sender, address instance);

    mapping(address => address[]) public registry;

    function create(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _holdPeriod,
        TokenValidator _validator
    ) public returns (address _deal) {
        address deal =
          new Deal(_name, _symbol, _granularity, _startTime, _endTime, _holdPeriod, _validator);

        registry[msg.sender].push(deal);
        DealCreated(msg.sender, deal);

        return deal;
    }

    function mine() public view returns (address[]) { return registry[msg.sender]; }
}
