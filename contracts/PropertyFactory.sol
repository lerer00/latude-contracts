pragma solidity ^0.4.21;

import "./Property.sol";

contract PropertyFactory {
    address public exchangeContract;
    mapping(address => address[]) properties;
    event PropertyCreated (address property);

    constructor(address _exchangeContract) public {
        exchangeContract = _exchangeContract;
    }

    function addProperty(string id) public returns (Property) {
        // create new property
        Property newProperty = new Property(id, msg.sender, exchangeContract);

        // propeties are added under a single owner
        properties[msg.sender].push(newProperty);
        emit PropertyCreated(newProperty);

        // return newly added property 
        return newProperty;
    }

    function getProperties() public view returns(address[]) {
        return properties[msg.sender];
    }
}