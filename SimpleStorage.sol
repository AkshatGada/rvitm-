//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract simplestorage {
    uint256 number;

    function set(uint256 num) public {
        number = num;
    }

    function retreive() public view returns (uint256){
          return number;
    }

}