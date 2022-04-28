const ERC20Token = artifacts.require("ERC20Token");

module.exports = function (deployer) {
  //uint256 _initialAmount, string memory _tokenName, uint8 _decimalUnits, string  memory _tokenSymbol
  deployer.deploy(ERC20Token, 100000000, "LOGLOG", 8, "LOG");
};
