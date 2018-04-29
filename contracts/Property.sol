pragma solidity ^0.4.18;

import "./Authorization.sol";
import "./PropertyAuthority.sol";
import "./ExchangeRates.sol";
import "./StayLinkedList.sol";

contract Property is Authorization, StayLinkedList {
    string public name;
    mapping(uint => mapping(uint => Stay)) public stays;
    
    // All assets are tracked within this array.
    Asset[] private assets;
    // We need to query an already deployed exhange.
    ExchangeRates private exchangeRates;
    // We need to attach to the good authority
    PropertyAuthority private propertyAuthority;
    event AssetCreated (uint asset, uint price, bytes32 currency);
    event StayCreated (uint asset, uint id, uint duration);

    // We are using the unix epoch format.
    struct Stay {
        uint startTime;
        uint endTime;
        address user;
    }

    // Basic information about an asset, more details will be provided by ipfs.
    struct Asset {
        uint id;
        uint price;
        bytes32 currency;
    }

    function Property(string _name, address _owner, address _exchangeContract) public payable {
        setOwner(_owner);
        setAuthority(propertyAuthority);
        name = _name;
        // Make sure this contract is always calling the same exchange to convert user currency into ETH.
        exchangeRates = ExchangeRates(_exchangeContract);        
    }

    // Asset management ////////////////
    function addAsset(uint price, bytes32 currency) onlyOwner public {
        require(exchangeRates.isCurrencyAllowed(currency));

        uint newAssetId = assets.length;
        StayLinkedList.initializeAssetList(newAssetId);
        assets.push(Asset(newAssetId, price, currency));
        AssetCreated(newAssetId, price, currency);
    }

    function getAsset(uint id) public view returns (uint, uint, bytes32) {
        Asset memory asset = assets[id];
        return (asset.id, asset.price, asset.currency);
    }

    // Stay management ////////////////
    function addStay(uint assetId, uint startTime, uint endTime) public payable {
        require(endTime > startTime);
        require(now <= startTime);
        
        // Check that duration is legitimate.
        uint stayDurationInDays = (endTime - startTime) / 60 / 60 / 24;

        // Check if the amount of wei sent is sufficient.
        uint weiPriceForTheStay = getStayPriceInWei(assetId, stayDurationInDays);
        require(msg.value >= weiPriceForTheStay);

        // Here we'll need to return all surpluses to the paying user
        // msg.value - weiPriceForTheStay -> return to msg.sender

        // Add the stay within the linked list.
        StayLinkedList.insertNode(assetId, startTime, endTime - startTime);
        
        // Map it within stays.
        stays[assetId][startTime] = Stay(startTime, endTime, msg.sender);
        StayCreated(assetId, startTime, stayDurationInDays);
    }

    function getStay(uint assetId, uint stayId) public view returns(uint, uint, address) {
        Stay memory stay = stays[assetId][stayId];
        return (stay.startTime, stay.endTime, stay.user);
    }

    function getStays(uint assetId, uint from, uint to) public view returns(uint[]) {
        return StayLinkedList.getNodesBetween(assetId, from, to);
    }

    function getStayPriceInWei(uint assetId, uint stayDurationInDays) public view returns(uint) {
        require(stayDurationInDays > 0);

        Asset memory asset = assets[assetId];
        uint weiPriceForSingleDay = ((asset.price * 100 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000) / exchangeRates.getCurrencyRate(asset.currency));
        uint weiPriceForTheStay = weiPriceForSingleDay * stayDurationInDays;

        return weiPriceForTheStay;
    }

    // TODO, this is somewhat obscur since we need this because id are created from 0 - inf
    function numberOfAssets() public view returns(uint) {
        return assets.length;
    }
}