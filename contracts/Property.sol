pragma solidity ^0.4.21;

import "./Authorization.sol";
import "./PropertyAuthority.sol";
import "./ExchangeRates.sol";
import "./WheightedLinkedList.sol";

contract Property is Authorization, WheightedLinkedList {
    string public id;
    
    // all assets are tracked within this array
    Asset[] private assets;

    // all bookings are traked within this map
    mapping(uint => mapping(uint => Booking)) public bookings;

    // we need to query an already deployed exhange
    ExchangeRates private exchangeRates;

    // we need to attach to the good authority
    PropertyAuthority private propertyAuthority;

    // events
    event AssetCreated (uint asset, uint price, bytes32 currency);
    event BookingCreated (uint asset, uint id, uint duration);

    struct Booking {
        uint startTime;
        uint endTime;
        address user;
    }

    struct Asset {
        uint id;
        uint price;
        bytes32 currency;
    }

    constructor(string _id, address _owner, address _exchangeContract) public payable {
        setOwner(_owner);
        setAuthority(propertyAuthority);
        id = _id;
        
        // make sure this contract is always calling the same exchange to convert user currency into eth.
        exchangeRates = ExchangeRates(_exchangeContract);        
    }

    function addAsset(uint price, bytes32 currency) onlyOwner public {
        require(exchangeRates.isCurrencyAllowed(currency));

        // ids are generated with the last inserted id + 1
        uint newAssetId = assets.length;

        // initilize his weighted list to keep all bookings
        WheightedLinkedList.initialize(newAssetId);

        assets.push(Asset(newAssetId, price, currency));
        emit AssetCreated(newAssetId, price, currency);
    }

    function withdraw(uint amount) onlyOwner public {
        require(amount <= address(this).balance);
        owner.transfer(amount);
    }

    function getAsset(uint _id) public view returns (uint, uint, bytes32) {
        Asset memory asset = assets[_id];
        return (asset.id, asset.price, asset.currency);
    }

    function addBooking(uint assetId, uint startTime, uint endTime) public payable {
        require(endTime > startTime);
        require(now <= startTime);
        
        // check that duration is legit
        uint bookingDurationInDays = (endTime - startTime) / 60 / 60 / 24;

        // check if the amount of wei sent is sufficient.
        uint weiPriceForTheBooking = getBookingPriceInWei(assetId, bookingDurationInDays);
        require(msg.value >= weiPriceForTheBooking);

        // refunding all extra eth back to user
        // msg.value - weiPriceForTheBooking -> return to msg.sender

        // add the Booking within the linked list
        WheightedLinkedList.insertNode(assetId, startTime, bookingDurationInDays);
        bookings[assetId][startTime] = Booking(startTime, endTime, msg.sender);
        emit BookingCreated(assetId, startTime, bookingDurationInDays);
    }

    function getBooking(uint assetId, uint bookingId) public view returns(uint, uint, address) {
        Booking memory booking = bookings[assetId][bookingId];
        return (booking.startTime, booking.endTime, booking.user);
    }

    function getBookings(uint assetId, uint from, uint to) public view returns(uint[]) {
        return WheightedLinkedList.getNodesBetween(assetId, from, to);
    }

    function getBookingPriceInWei(uint assetId, uint d) public view returns(uint) {
        require(d > 0);

        Asset memory asset = assets[assetId];
        uint weiForOneDay = ((asset.price * 100 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000) / exchangeRates.getCurrencyRate(asset.currency));
        uint weiForWholeBooking = weiForOneDay * d;

        return weiForWholeBooking;
    }

    // TODO, this is somewhat obscur since we need this because id are created from 0 - inf
    function numberOfAssets() public view returns(uint) {
        return assets.length;
    }
}