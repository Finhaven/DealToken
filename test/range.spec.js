const { expect } = require('chai');
const RangeMock = artifacts.require('RangeMock'); // eslint-disable-line no-undef

contract('Range', () => { // eslint-disable-line no-undef
  let rangeMock;

  before(async () => {
    rangeMock = await RangeMock.new();
  });

  describe('#isBetween', () => {
    it('is true when the first value is between the others', async () => {
      const result = await rangeMock.test(2, 1, 3);
      expect(Boolean(result)).to.be.true;
    });

    it('is true when the first value is equal to the low value', async () => {
      const result = await rangeMock.test(1, 1, 2);
      expect(Boolean(result)).to.be.true;
    });

    it('is false when the first value is below both values', async () => {
      const result = await rangeMock.test(1, 2, 3);
      expect(Boolean(result)).to.be.false;
    });

    it('is false when range values are reversed', async () => {
      const result = await rangeMock.test(2, 3, 1);
      expect(Boolean(result)).to.be.false;
    });

    it('is false when above the highest value', async () => {
      const result = await rangeMock.test(3, 1, 2);
      expect(Boolean(result)).to.be.false;
    });

    it('is false when it is equal to the same as highest value', async () => {
      const result = await rangeMock.test(2, 1, 2);
      expect(Boolean(result)).to.be.false;
    });
  });
});
