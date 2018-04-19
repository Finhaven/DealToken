pragma solidity ^0.4.21;

import './Deal.sol';

contract DealFactory {
    event DealCreated(address sender, Deal deal);
    mapping(address => Deal[]) private registry;

    function create(
        string _name,
        string _symbol,
        uint256 _granularity,
        uint256 _mintStartTime,
        uint256 _holdStartTime,
        uint256 _transferStartTime,
        TokenValidator _validator
    ) public returns (Deal _deal) {
        Deal deal =
          new Deal(
              _name,
              _symbol,
              _granularity,
              _mintStartTime,
              _holdStartTime,
              _transferStartTime,
              _validator
          );

        registry[msg.sender].push(deal);
        emit DealCreated(msg.sender, deal);

        return deal;
    }

    function mine() public view returns (Deal[]) {
        return registry[msg.sender];
    }
}
