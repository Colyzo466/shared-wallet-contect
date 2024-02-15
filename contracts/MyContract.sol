// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyContract{
    string public name = "hashlips";

    function updateName(string memory _newName)public {
        name = _newName;
    }
}