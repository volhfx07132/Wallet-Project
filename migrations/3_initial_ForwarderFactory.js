const ForwarderFactory = artifacts.require("ForwarderFactory");

module.exports = function (deployer) {
  deployer.deploy(ForwarderFactory);
};
