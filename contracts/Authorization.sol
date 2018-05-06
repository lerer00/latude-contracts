pragma solidity ^0.4.18;

contract Authority {
    function canCall(address caller, address target, bytes4 sig) public view returns (bool);
}

contract Authorization {
    Authority public authority;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function setOwner(address newOwner) onlyOwner public {
        require(newOwner != address(0));
        owner = newOwner;
    }

    function setAuthority(Authority newAuthority) internal {
        authority = newAuthority;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAuthorized {
        require(isAuthorized(msg.sender, msg.sig));
        _;
    }

    function terminate() onlyOwner public {
        selfdestruct(owner);
    }

    function isAuthorized(address caller, bytes4 sig) internal view returns (bool) {
        if (caller == address(this)) {
            return true;
        } else if (caller == owner) {
            return true;
        } else if (authority == Authority(0)) {
            return false;
        } else {
            return authority.canCall(caller, this, sig);
        }
    }
}