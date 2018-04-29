// var Authorization = artifacts.require("Authorization.sol");

// contract("Authorization", function (accounts) {
    // it("should have set the owner to the creator", function () {
    //     return Authorization.deployed().then(function (instance) {
    //         return instance.owner.call();
    //     }).then(function (owner) {
    //         assert.equal(owner, accounts[0], "owner does not match");
    //     });
    // });

    // it("should change the ownership", function () {
    //     var tmpInstance;
    //     return Authorization.deployed().then(function (instance) {
    //         tmpInstance = instance;
    //         return tmpInstance.transferOwnership(accounts[1]);
    //     }).then(function (transaction) {
    //         return tmpInstance.owner.call();
    //     }).then(function (owner) {
    //         assert.equal(owner, accounts[1], "current owner " + owner + " does not match the desired one " + accounts[1]);
    //     });
    // });

    // it("shouldn't change the ownership since i'm not the owner anymore", function () {
    //     var tmpInstance;
    //     return Authorization.deployed().then(function (instance) {
    //         tmpInstance = instance;
    //         return tmpInstance.transferOwnership(accounts[1]);
    //     }).then(function (transaction) {
    //         return tmpInstance.transferOwnership(accounts[0]);
    //     }).then(function (owner) {
    //         assert(true, "error should have been thrown since i'm not the owner of this contract anymore.");
    //     }).catch(function (error) {
    //         if (error.toString().indexOf("invalid opcode") == -1)
    //             assert(true, "an error occur but it was not the intended one.");
    //     });
    // });

    // TODO investigate how to test this function.
    // it("should terminate the contract life returning all fund to it's owner", function () {
    //     var tmpInstance;
    //     return Authorization.deployed().then(function (instance) {
    //         tmpInstance = instance;
    //         return tmpInstance.terminate.call();
    //     }).then(function (transaction) {
    //         console.log(transaction);
    //         return tmpInstance.owner.call();
    //     }).then(function (owner) {
    //         console.log(owner);
    //         assert.equal(owner, 0, "owner is not set to 0 which mean the contract is still alive");
    //     });
    // });
// });