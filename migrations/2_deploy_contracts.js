const DealFactory = artifacts.require('./DealFactory.sol');

module.exports = (deployer) => {
  // let gasLimit = web3.eth.getBlock('pending').gasLimit;
  // console.log('block gasLimit',gasLimit);
  deployer.deploy(DealFactory);
};
