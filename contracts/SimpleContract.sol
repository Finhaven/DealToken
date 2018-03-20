pragma solidity ^0.4.15;

// a simple contract just for testing smart contract interactions

contract SimpleContract {

    int public value = 0;

    function add(int _value) public {
        value = value + _value;
    }

    function SimpleContract(int initialValue) {
        value = initialValue;
    }

}