const utils = require('../../../src/lib/contract-utils');

const Deal = artifacts.require('./Deal');
const DealFactory = artifacts.require('./DealFactory');
const DealToken = artifacts.require('./DealToken');


contract('DealFactory', (accounts) => {
  let deal,
    dealFactory,
    weiToTokenRate;

  const getInstance = () =>
    DealFactory
      .deployed()
      .then((instance) => {
        dealFactory = instance;
      });

  const createDeal = (options) => {
    const {
      startTime, endTime, rate, wallet,
    } = options;
    weiToTokenRate = rate;
    return dealFactory
      .createDeal(startTime, endTime, rate, wallet)
      .then(tx => utils.getParamFromTxEvent(tx, 'instance', null, 'DealCreated'))
      .then(address => Deal.at(address))
      .then((instance) => {
        deal = instance;
      });
  };


  beforeEach(() => getInstance()
    .then(() => createDeal(utils.getDealParameters(accounts[5]))));

  const getTokenContract = _deal =>
    _deal
      .token()
      .then(address => DealToken.at(address));

  it('should get instance of deal factory', () => {
    assert.ok(dealFactory);
  });

  it('should create deal', () => assert.isNotNull(deal));

  it('should authorize investor', () => {
    const investor = accounts[9];
    return Promise.resolve(deal.authorize(investor));
  });

  it('should allow authorized investor to buy tokens', () => {
    const investor = accounts[9];
    const weiInvested = 3;
    return Promise.resolve()
      .then(() => deal.authorize(investor))
      .then(() => deal
        .sendTransaction({
          value: weiInvested, from: investor, to: deal,
        }))
      .then(() => getTokenContract(deal))
      .then(token => token.balanceOf(investor))
      .then(balance => assert.equal(weiInvested * weiToTokenRate, balance.toNumber()));
  });

  it('should not allow an unauthorized investor to buy tokens', () => {
    const investor = accounts[8];
    const ethAmount = 3;
    return deal
      .sendTransaction({
        value: ethAmount, from: investor, to: deal,
      })
      .then(() => assert.fail('transaction succeeded', 'transfer should have failed'))
      .catch((e) => {
        console.log('transfer failed, yay', e);
      })
      .then(() => getTokenContract(deal))
      .then(token => token.balanceOf(investor))
      .then(balance => assert.equal(0, balance.toNumber()));
  });
});

