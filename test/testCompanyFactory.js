// var CompanyFactory = artifacts.require("CompanyFactory.sol");

// contract("CompanyFactory", function (accounts) {
// 	it("should have an empty array of companies", function () {
// 		return CompanyFactory.deployed().then(function (instance) {
// 			return instance.getCompanies.call();
// 		}).then(function (companies) {
// 			assert.equal(companies.length, 0, "array of companies isn't empty");
// 		});
// 	});

// 	it("should have the predefined ExchangeRates contract address", function () {
// 		return CompanyFactory.deployed().then(function (instance) {
// 			return instance.exchangeContract.call();
// 		}).then(function (address) {
// 			assert.equal(address, "0x746535b7e5b157aee6e83eee76420d5130cf90dc", "ExchangeRates contract address does not match.")
// 		});
// 	});

// 	it("should add new company properly", function () {
// 		var tmpInstance;
// 		var companyName = "JohnCompany";
// 		return CompanyFactory.deployed().then(function (instance) {
// 			tmpInstance = instance;
// 			return tmpInstance.addCompany(companyName, { from: accounts[0] });
// 		}).then(function (transaction) {
// 			return tmpInstance.getCompanies.call();
// 		}).then(function (companies) {
// 			assert.equal(companies.length, 1, "company instance isn't added");
// 		});
// 	});
	
// 	it("should throw an error since name is empty when creating a company", function () {
// 		return CompanyFactory.deployed().then(function (instance) {
// 			return instance.addCompany("", { from: accounts[0] });
// 		}).then(function (unknown) {
// 			assert(true, "error should have been thrown since name length is 0.")
// 		}).catch(function (error) {
// 			if(error.toString().indexOf("invalid opcode") == -1)
// 				assert(true, "an error occur but it was not the intended one.")
// 		});
// 	});
// });