const { expect } = require('chai');

const DealValidator = artifacts.require('DealValidator'); // eslint-disable-line no-undef
const ExtendedDealValidator = artifacts.require('ExtendedDealValidator'); // eslint-disable-line no-undef

contract('DealValidator', (accounts) => { // eslint-disable-line no-undef
  const [address, to] = accounts;

  let validator;
  let extendedValidator;

  before(async () => {
    validator = await DealValidator.new();
    extendedValidator = await ExtendedDealValidator.new();
    await extendedValidator.setAuth(address, true);
  });

  // describe('#DealValidator', () => {
  //   it('has an owner', async () => {
  //     const owner = await validator.owner();
  //     expect(owner).to.match(/^0x[a-z0-9]+/);
  //   });
  // });

  // describe('#setAuth', () => {
  //   it('sets a user to valid', async () => {
  //     const result = await extendedValidator.check2.call('0x0', address);
  //     expect(result).to.equal('0x11');
  //   });

  //   it('sets a user to invalid', async () => {
  //     const result = await extendedValidator.check2.call('0x0', to);
  //     expect(String(result)).to.equal('0x10');
  //   });
  // });

  // describe('token validation', () => {

  // });
});
