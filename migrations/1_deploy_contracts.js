const AmiCatToken = artifacts.require("AmiCatToken");

module.exports = function(deployer) {
  deployer.deploy(AmiCatToken);
};
