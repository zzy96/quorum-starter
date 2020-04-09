pragma solidity ^0.5.0;

import './simpleStorage.sol';

contract SimpleStorageWrapper {
  address private a;

  constructor(address _a) public {
    a = _a;
  }

  function set(uint256 _x) public {
    SimpleStorage(a).set(_x);
  }

  function get() public view returns (uint256) {
    return SimpleStorage(a).get();
  }
}
