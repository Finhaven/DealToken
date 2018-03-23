const chai = require('chai');
const assert = chai.assert;

const web3 = require('web3');
const { accounts } = require('./accounts');
const Deal = artifacts.require('./Deal');
const DealToken = artifacts.require('./DealToken');
const utils = require('../node_modules/web3-server-tools/src/lib/contract-utils');

contract('Deal', (accounts) => {
  let deal;
  let dealToken;
  let weiToTokenRate;

  const createDeal = () => {
    const dealOptions = utils.getDealParameters(accounts[5]);
    const { startTime, endTime, rate: weiToTokenRate, wallet } = dealOptions;
    return Deal.new(startTime, endTime, weiToTokenRate, wallet);
  };

  beforeEach(() => createDeal()
    .then((s) => { deal = s; })
    .then(() => deal.token())
    .then(address => DealToken.at(address))
    .then((token) => {
      dealToken = token;
    }));

  it('should get instance of deal', () => {
    console.log('contract address', deal.address);
    assert.isNotNull(deal);
  });

  it('should get token from deal', async () =>
     Promise
       .resolve(deal.token())
       .then(async (token) => {
         console.log('token address', token);
         dealToken = await DealToken.at(token);
         // console.log('dealToken', dealToken);
         return dealToken.balanceOf.call(accounts[0], { from: accounts[0] });
       })
       .then((balance) => {
         console.log('balance of token', balance.toNumber());
         assert.equal(0, balance.toNumber());
       })
    );

  it('should allow investment in deal', () => {
    const account = accounts[0];
    const weiAmount = web3.utils.toWei('1', 'ether');

    return Promise.all([deal.startTime(), deal.endTime()])
      .then(([startTime, endTime]) => {
        const now = Math.ceil(Date.now() / 1000);

        // console.log(`elapsed=${elapsed} left=${left} - contract start time ${startTime.toNumber()} ${endTime.toNumber()}`);
        // let elapsed = (now) - startTime.toNumber();
        // let left = endTime.toNumber() - (now);
        //
        assert.isAtLeast(now, startTime, 'deal has started');
        assert.isAtMost(now, endTime, 'deal has not finished');
      })
      .then(deal.authorize(account))
      .then(() => {
        const tx = { from: accounts[0], value: weiAmount };
        console.log('sending transaction', tx);
        return deal.sendTransaction(tx);
      })
      .then((/* sendResult */) =>
        // console.log('send result', sendResult);
        dealToken.balanceOf(accounts[0], { from: accounts[0] }))
      .then((balance) => {
        console.log('balance of token after', balance.toNumber());
        assert.equal(weiToTokenRate * weiAmount, balance.toNumber());
      });
  });
});
