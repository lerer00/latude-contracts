pragma solidity ^0.4.18;

import "./Authorization.sol";
import "./CompanyAuthority.sol";
import "./Property.sol";

contract Company is Authorization {
    string public name;
    address public exchangeContract;
    address[] public properties;
    CompanyAuthority private companyAuthority;
    event PropertyCreated (address property);

    function Company(string _name, address _owner, address _exchangeContract) public payable {
        setOwner(_owner);
        setAuthority(companyAuthority);
        name = _name;
        exchangeContract = _exchangeContract;
    }

    function addProperty(string _name) onlyAuthorized public returns (Property) {
        Property newProperty = new Property(_name, owner, exchangeContract);
        properties.push(newProperty);
        PropertyCreated(newProperty);
        return newProperty;
    }

    function getProperties() public view returns(address[]) {
        return properties;
    }
}