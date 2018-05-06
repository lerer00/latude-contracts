var ExchangeRates = artifacts.require("./ExchangeRates.sol");
var PropertyFactory = artifacts.require("./PropertyFactory.sol");

module.exports = function (deployer) {
  deployer.deploy(ExchangeRates, { value: 1000000000000000000 }).then(() => {
    return deployer.deploy(PropertyFactory, ExchangeRates.address);
  });
};
