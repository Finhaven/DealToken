const { expect } = require('chai');
const { expectRevert, getNow } = require('./helpers');

const DealValidator = artifacts.require('DealValidator'); // eslint-disable-line no-undef
const ExtendedDealValidator = artifacts.require('ExtendedDealValidator'); // eslint-disable-line no-undef

contract('DealValidator', (accounts) => { // eslint-disable-line no-undef
  const [address, to, from] = accounts;

  let validator;
  let extendedValidator;

  before(async () => {
    validator = await DealValidator.new();
    extendedValidator = await ExtendedDealValidator.new();
  });

  describe('#DealValidator', () => {
    it('can be instantiated', () => {
      expect(async () => await DealValidator.new()).to.not.throw();
    });

    it('has an owner', async () => {
      const owner = await validator.owner();
      expect(owner).to.match(/^0x[a-z0-9]+/);
    });
  });

  describe('#setAuth', () => {
    it('sets a user to valid', async () => {
      // const result = await extendedValidator.setAuth(to, true);
      const result = await extendedValidator.check2(to, from);
      console.log(`>>>>>>>>>>>> ${result}`);
      expect(result).to.equal('0x11');
    });

    // it('sets a user to invalid', async () => {
    //   await extendedValidator.setAuth(address, false);
    //   const result = await extendedValidator.check2(0x0, address);
    //   expect(String(result)).to.equal('0x10');
    // });
  });

  describe('token validation', () => {

  });
});
