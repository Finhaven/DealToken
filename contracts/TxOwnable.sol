pragma solidity ^0.4.15;


/**
 * @title TxOwnable
 * @dev The TxOwnable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".  Same as "Ownable" but defaults to tx.origin instead of msg.sender
 */
contract TxOwnable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the `owner` based on the contructor arg
   */
  function TxOwnable() {
    owner = tx.origin;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}
