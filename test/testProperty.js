// var Property = artifacts.require("Property.sol");

// contract("Property", function (accounts) {
//     it("should have an empty array of assets", function () {
//         return Property.deployed().then(function (instance) {
//             return instance.numberOfAssets.call();
//         }).then(function (assets) {
//             assert.equal(assets, 0, "array of assets isn't empty");
//         });
//     });

//     it("should have the right property name on creation", function () {
//         return Property.deployed().then(function (instance) {
//             return instance.name.call();
//         }).then(function (name) {
//             assert.equal(name, "monterey", "Property name does not match");
//         });
//     });

//     it("should have set the owner to the creator", function () {
//         return Property.deployed().then(function (instance) {
//             return instance.owner.call();
//         }).then(function (owner) {
//             assert.equal(owner, accounts[0], "Owner does not match");
//         });
//     });

//     it("should add an asset properly", function () {
//         var assetId;
//         var assetPrice = 20;
//         var assetCurrency = "CAD";
//         var tmpInstance;
//         return Property.deployed().then(function (instance) {
//             tmpInstance = instance;
//             return tmpInstance.numberOfAssets.call();
//         }).then(function (numberOfAssets) {
//             assetId = numberOfAssets.toNumber();
//             return tmpInstance.addAsset(assetPrice, assetCurrency);
//         }).then(function (transaction) {
//             return tmpInstance.getAsset(assetId);
//         }).then(function (asset) {
//             assert.equal(asset[0].toNumber(), 0, "asset id does not match");
//             assert.equal(asset[1].toNumber(), assetPrice, "asset price does not match");

//             // This is CAD in byte32.
//             assert.equal(asset[2], '0x4341440000000000000000000000000000000000000000000000000000000000', "asset currency does not match");
//             return tmpInstance.numberOfAssets.call();
//         }).then(function (numberOfAssets) {
//             assert.equal(numberOfAssets, assetId + 1, 'number of assets was not incremented');
//         });
//     });

//     it("shouldn't add an asset because curreny is not supported", function () {
//         var assetPrice = 20;
//         var assetCurrency = "BTC";
//         return Property.deployed().then(function (instance) {
//             return instance.addAsset(assetPrice, assetCurrency);
//         }).then(function (unknown) {
//             assert(true, "error should have been thrown since the currency is not supported.");
//         }).catch(function (error) {
//             if (error.toString().indexOf("invalid opcode") == -1)
//                 assert(true, "an error occur but it was not the intended one.")
//         });
//     });

//     it("should add an IPFS metadata hash", function () {
//         var ipfsHash = "QmW2WQi7j6c7UgJTarActp7tDNikE4B2qXtFCfLPdsgaTQ";
//         var assetId;
//         var assetPrice = 20;
//         var assetCurrency = "CAD";
//         var tmpInstance;
//         return Property.deployed().then(function (instance) {
//             tmpInstance = instance;
//             return tmpInstance.numberOfAssets.call();
//         }).then(function (numberOfAssets) {
//             assetId = numberOfAssets.toNumber();
//             return tmpInstance.addAsset(assetPrice, assetCurrency);
//         }).then(function (transaction) {
//             return tmpInstance.addMetadataHashForAsset(assetId, ipfsHash)
//         }).then(function (transaction) {
//             return tmpInstance.lastMetadataHashForAsset.call(assetId);
//         }).then(function (lastHash) {
//             assert.equal(lastHash, ipfsHash)
//         });
//     });

//     it("shouldn't add an IPFS metadata hash since asset does not exist", function () {
//         return Property.deployed().then(function (instance) {
//             return tmpInstance.addMetadataHashForAsset(20, ipfsHash);
//         }).then(function (unknown) {
//             assert(true, "error should have been thrown since asset does not exist.");
//         }).catch(function (error) {
//             if (error.toString().indexOf("invalid opcode") == -1)
//                 assert(true, "an error occur but it was not the intended one.");
//         });
//     });

//     it("should add a stay properly", function () {
//         var assetId;
//         var assetPrice = 20;
//         var assetCurrency = "CAD";

//         // Get unix date +20 days from now and +30 days from now.
//         var start = new Date();
//         var end = new Date();
//         start.setDate(start.getDate() + 20);
//         end.setDate(end.getDate() + 30);
//         var startUnix = Math.round(start.getTime() / 1000);
//         var endUnix = Math.round(end.getTime() / 1000);

//         var tmpInstance;
//         return Property.deployed().then(function (instance) {
//             tmpInstance = instance;
//             return tmpInstance.numberOfAssets.call();
//         }).then(function (numberOfAssets) {
//             assetId = numberOfAssets.toNumber();
//             return tmpInstance.addAsset(assetPrice, assetCurrency);
//         }).then(function (transaction) {
//             return tmpInstance.getStayPriceInWei.call(assetId, 10);
//         }).then(function (priceInWei) {
//             return tmpInstance.addStay(assetId, startUnix, endUnix, { value: priceInWei });
//         }).then(function (transaction) {
//             return tmpInstance.getStay(assetId, startUnix);
//         }).then(function (stay) {
//             assert.equal(stay[0].toNumber(), startUnix, "stay start unix time does not match");
//             assert.equal(stay[1].toNumber(), endUnix, "stay end unix time does not match");
//             assert.equal(stay[2], accounts[0], "user address does not match");
//         });
//     });

//     it("shouldn't add a stay since start date is lower than today", function () {
//         var assetId;
//         var assetPrice = 20;
//         var assetCurrency = "CAD";

//         // Get unix from now and +30 days from now.
//         var end = new Date();
//         end.setDate(end.getDate() + 30);
//         var endUnix = Math.round(end.getTime() / 1000);

//         var tmpInstance;
//         return Property.deployed().then(function (instance) {
//             tmpInstance = instance;
//             return tmpInstance.numberOfAssets.call();
//         }).then(function (numberOfAssets) {
//             assetId = numberOfAssets.toNumber();
//             return tmpInstance.addAsset(assetPrice, assetCurrency);
//         }).then(function (transaction) {
//             return tmpInstance.getStayPriceInWei.call(assetId, 10);
//         }).then(function (priceInWei) {
//             return tmpInstance.addStay(assetId, 0, endUnix, { value: priceInWei });
//         }).then(function (unknown) {
//             assert(true, "error should have been thrown since the start date is lower than today.");
//         }).catch(function (error) {
//             if (error.toString().indexOf("invalid opcode") == -1)
//                 assert(true, "an error occur but it was not the intended one.");
//         });
//     });

//     it("shouldn't add a stay since end date is lower than start date", function () {
//         var assetId;
//         var assetPrice = 20;
//         var assetCurrency = "CAD";

//         // Make sure that end date is smaller thant start date.
//         var start = new Date();
//         var end = new Date();
//         start.setDate(start.getDate());
//         end.setDate(end.getDate() - 30);
//         var startUnix = Math.round(start.getTime() / 1000);
//         var endUnix = Math.round(end.getTime() / 1000);

//         var tmpInstance;
//         return Property.deployed().then(function (instance) {
//             tmpInstance = instance;
//             return tmpInstance.numberOfAssets.call();
//         }).then(function (numberOfAssets) {
//             assetId = numberOfAssets.toNumber();
//             return tmpInstance.addAsset(assetPrice, assetCurrency);
//         }).then(function (transaction) {
//             return tmpInstance.getStayPriceInWei.call(assetId, 10);
//         }).then(function (priceInWei) {
//             return tmpInstance.addStay(assetId, startUnix, endUnix, { value: priceInWei });
//         }).then(function (unknown) {
//             assert(true, "error should have been thrown since the end date is lower than the start date.");
//         }).catch(function (error) {
//             if (error.toString().indexOf("invalid opcode") == -1)
//                 assert(true, "an error occur but it was not the intended one.");
//         });
//     });

//     it("shouldn't add a stay since the duration is equal to 0", function () {
//         var assetId;
//         var assetPrice = 20;
//         var assetCurrency = "CAD";

//         // Make sure that end date is smaller thant start date.
//         var date = new Date();
//         var dateUnix = Math.round(date.getTime() / 1000);

//         var tmpInstance;
//         return Property.deployed().then(function (instance) {
//             tmpInstance = instance;
//             return tmpInstance.numberOfAssets.call();
//         }).then(function (numberOfAssets) {
//             assetId = numberOfAssets.toNumber();
//             return tmpInstance.addAsset(assetPrice, assetCurrency);
//         }).then(function (transaction) {
//             return tmpInstance.getStayPriceInWei.call(assetId, 10);
//         }).then(function (priceInWei) {
//             return tmpInstance.addStay(assetId, dateUnix, dateUnix, { value: priceInWei });
//         }).then(function (unknown) {
//             assert(true, "error should have been thrown since the stay duration is equal to 0.");
//         }).catch(function (error) {
//             if (error.toString().indexOf("invalid opcode") == -1)
//                 assert(true, "an error occur but it was not the intended one.");
//         });
//     });

//     it("shouldn't add a stay since msg.value is lower than the price of the stay", function () {
//         var assetId;
//         var assetPrice = 20;
//         var assetCurrency = "CAD";

//         // Get unix date +20 days from now and +30 days from now.
//         var start = new Date();
//         var end = new Date();
//         start.setDate(start.getDate() + 20);
//         end.setDate(end.getDate() + 30);
//         var startUnix = Math.round(start.getTime() / 1000);
//         var endUnix = Math.round(end.getTime() / 1000);

//         var tmpInstance;
//         return Property.deployed().then(function (instance) {
//             tmpInstance = instance;
//             return tmpInstance.numberOfAssets.call();
//         }).then(function (numberOfAssets) {
//             assetId = numberOfAssets.toNumber();
//             return tmpInstance.addAsset(assetPrice, assetCurrency);
//         }).then(function (transaction) {
//             return tmpInstance.getStayPriceInWei.call(assetId, 10);
//         }).then(function (priceInWei) {
//             return tmpInstance.addStay(assetId, startUnix, endUnix, { value: 1 });
//         }).then(function (unknown) {
//             assert(true, "error should have been thrown since the msg.value is lower than the price of the stay.");
//         }).catch(function (error) {
//             if (error.toString().indexOf("invalid opcode") == -1)
//                 assert(true, "an error occur but it was not the intended one.");
//         });
//     });
// });