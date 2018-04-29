// var ExchangeRates = artifacts.require("./ExchangeRates.sol");
// var Company = artifacts.require("Company.sol");

// contract("Company", function (accounts) {
// 	it("should have an empty array of properties", function () {
// 		return Company.deployed().then(function (instance) {
// 			return instance.getProperties.call();
// 		}).then(function (properties) {
// 			assert.equal(properties.length, 0, "array of properties isn't empty");
// 		});
// 	});

// 	it("should have the predefined ExchangeRates contract address", function () {
// 		return Company.deployed().then(function (instance) {
// 			return instance.exchangeContract.call();
// 		}).then(function (address) {
// 			assert.equal(address, "0x746535b7e5b157aee6e83eee76420d5130cf90dc", "ExchangeRates contract address does not match.")
// 		});
// 	});

// 	it("should have the right company name on creation", function () {
// 		return Company.deployed().then(function (instance) {
// 			return instance.name.call();
// 		}).then(function (name) {
// 			assert.equal(name, "hilton", "Company name does not match");
// 		});
// 	});

// 	it("should have set the owner to the creator", function () {
// 		return Company.deployed().then(function (instance) {
// 			return instance.owner.call();
// 		}).then(function (owner) {
// 			assert.equal(owner, accounts[0], "Owner does not match");
// 		});
// 	});

// 	it("should add a property properly", function () {
// 		var tmpInstance;
// 		return Company.deployed().then(function (instance) {
// 			tmpInstance = instance;
// 			return tmpInstance.addProperty("monterey");
// 		}).then(function (transaction) {
// 			return tmpInstance.getProperties.call();
// 		}).then(function (properties) {
// 			assert.equal(properties.length, 1, "there's " + properties.length + " but we were expecting " + 1);
// 		});
// 	});

// 	it("should throw an error since name is empty when creating a property", function () {
// 		return Company.deployed().then(function (instance) {
// 			return instance.addProperty(companyName, { from: accounts[0] });
// 		}).then(function (unknown) {
// 			assert(true, "error should have been thrown since name length is 0.");
// 		}).catch(function (error) {
// 			if (error.toString().indexOf("invalid opcode") == -1)
// 				assert(true, "an error occur but it was not the intended one.");
// 		});
// 	});
// });