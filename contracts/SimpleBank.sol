+// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

contract SimpleBank {
    uint public totalBalance;
    mapping (address => uint) private balanceByAddress;

    constructor(){
        totalBalance = 0;
    }

    function getTotalBalance() external view return (uint){
        return totalBalance;
    }
}