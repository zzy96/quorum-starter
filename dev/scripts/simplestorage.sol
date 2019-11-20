pragma solidity ^0.5.0;

contract SimpleStorage {
  uint256 public storedData;

  event valueSet(uint256 _value);

  constructor(uint256 _initVal) public {
    storedData = _initVal;
  }

  function set(uint256 _x) public {
    storedData = _x;
    emit valueSet(_x);
  }

  function get() public view returns (uint256) {
    return storedData;
  }
}