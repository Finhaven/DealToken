const { assert } = require('chai');
const web3 = require('web3');

const { accounts } = require('./accounts');
const utils = require('../node_modules/web3-server-tools/src/lib/contract-utils');
const OpenValidator = artifacts.require('OpenValidator.sol');
const Deal = artifacts.require('./Deal'); // eslint-disable-line no-undef

contract('Deal', () => { // eslint-disable-line no-undef
  let deal;

  beforeEach(async () => {
    const validator = SimpleAuthorization.new();
    const dealAddr = await Deal.new("MyDeal", "MDL", 100, 0, 999999, 1000, validator);
    deal = Deal.at(dealAddr);
  });

  it('should get instance of deal', () => {
    console.log('contract address', deal.address);
    assert.isNotNull(deal);
  });
});
