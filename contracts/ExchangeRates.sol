pragma solidity ^0.4.18;

import "./Authorization.sol";
import "./strings.sol";
import "./usingOraclize.sol";

contract ExchangeRates is usingOraclize, Authorization {
    using strings for *;
    
    uint private delay;
    mapping(bytes32 => uint) private rates; 
    mapping(bytes32 => bool) private supportedCurrencies;
    mapping(bytes32=>bool) private validIds;

    function ExchangeRates() public payable {
        // Initialize the delay
        delay = 86400;

        // This should only be used when deploying to a local rpc.
        // OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);

        getCurrenciesRate(0);
    }

    function __callback(bytes32 myid, string currencies) public {
        // Make sure the call was done through our service.
        require(validIds[myid]);
        delete validIds[myid];

        // Try to uncomment when we'll try on geth or ropsten testrpc seems to run out of gas.
        //require(msg.sender == oraclize_cbAddress());

        // This flatten the whole string into an array ['l','a','t','u','d','e'].
        var currenciesRateStringArray = currencies.toSlice();
        var currenciesDelimiter = "|".toSlice();
        uint numberOfParts = currenciesRateStringArray.count(currenciesDelimiter) + 1;
        
        // Navigate through all parts that were seperated with an |.
        for (uint i = 0; i < numberOfParts; i++) {
            var currency = currenciesRateStringArray.split(currenciesDelimiter).toString();    
            var currencyStringArray = currency.toSlice();
            // Slice the CAD;398.05
            var currencyDelimeter = ";".toSlice();
            
            bytes32 sigle = stringToBytes32(currencyStringArray.split(currencyDelimeter).toString());
            string memory price = currencyStringArray.split(currencyDelimeter).toString();
            
            rates[sigle] = parseInt(price,2);
            supportedCurrencies[sigle] = true;
        }
        
        getCurrenciesRate(delay);
    }

    function getCurrenciesRate(uint d) internal {
        bytes32 queryId = oraclize_query(d, "URL", "json(https://latude-hub.herokuapp.com/rates).rates");
        validIds[queryId] = true;
    }

    function getCurrencyRate(bytes32 _currency) public view returns(uint) {
        return rates[_currency];
    }
    
    function isCurrencyAllowed(bytes32 _currency) public view returns(bool) {
        return supportedCurrencies[_currency];
    }

    function setDelay(uint newDelay) onlyOwner public {
        delay = newDelay;
    }
    
    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }
}