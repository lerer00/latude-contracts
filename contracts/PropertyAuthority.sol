pragma solidity ^0.4.21;

import "./Authorization.sol";

contract PropertyAuthority is Authority {
    function canCall(address caller, address target, bytes4 sig) public view returns (bool) {
        return true;
    }
}