pragma solidity ^0.4.19;

import './Deal.sol';

contract DealFactory {
    event DealCreated(address sender, Deal deal);

    // Any point making this private? It's all actually public anyways.
    mapping(address => Deal[]) private registry;
    // People can change public?
    // hash this?

    function create(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _holdPeriod,
        TokenValidator _validator
    ) public returns (Deal _deal) {
        Deal deal =
          new Deal(_name, _symbol, _granularity, _startTime, _endTime, _holdPeriod, _validator);

        registry[msg.sender].push(deal);
        DealCreated(msg.sender, deal);

        return deal;
    }

    function mine() public view returns (Deal[]) { return registry[msg.sender]; }
}
