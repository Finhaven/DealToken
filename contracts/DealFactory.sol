pragma solidity ^0.4.15;


import './Deal.sol';


contract DealFactory {
  event DealCreated(address sender, address instance);

  mapping(address => address[]) public instantiations;
  function createDeal(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public returns (address deal) {
    deal = new Deal(_startTime, _endTime, _rate, _wallet);
    instantiations[msg.sender].push(deal);
    DealCreated(msg.sender,deal);
    return deal;
  }
}
