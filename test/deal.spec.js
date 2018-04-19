const { expect } = require('chai');
const { accounts } = require('./accounts');
const OpenValidator = artifacts.require('OpenValidator');
const Deal = artifacts.require('Deal'); // eslint-disable-line no-undef

const expectRevert = async (func) => {
  try {
    await func();
    throw new Error('Should have failed');
  } catch ({message}) {
    expect(message).to.have.string('revert');
  }
};

contract('Deal', async () => { // eslint-disable-line no-undef
  const name = 'testDeal';
  const symbol = 'TDL';
  const granularity = 100;
  const startTime = 1;
  const endTime = 99999999999;
  const holdPeriod = 10000;

  let deal = null;

  const createDeal = async (params = {}) => {
    const {address: validatorAddress} = await OpenValidator.new();

    const normalized =
      Object.values({
        name,
        symbol,
        granularity,
        startTime,
        endTime,
        holdPeriod,
        validatorAddress,
        ...params
      });

    console.log(JSON.stringify(normalized));

    return await Deal.new(...normalized);
  };

  before(async () => {
    deal = await createDeal();
  });

  describe('#Deal', async () => {
    describe('ends before now', async () => {
      it('fails to deploy', async () => {
        await expectRevert(async () => await createDeal({endTime: startTime + 1}));
      });
    });

    describe('ends as soon as it begins', async () => {
      it('fails to deploy', async () => {
        await expectRevert(async () => await createDeal({endTime: startTime}));
      });
    });

    describe('ends before it begins', async () => {
      it('fails to deploy', async () => {
        await expectRevert(async () => await createDeal({endTime: startTime - 1}));
      });
    });

    describe('zero granularity', async () => {
      it('fails to deploy', async () => {
        await expectRevert(async () => await createDeal({granularity: 0}));
      });
    });

    describe('valid params', () => {
      it('deploys successfully', () => expect(deal).to.not.be.null);
    });
  });
});
