const { expect } = require('chai');
const { expectRevert, getNow } = require('../helpers');

const Closable = artifacts.require('Closable'); // eslint-disable-line no-undef

contract('Closable', () => { // eslint-disable-line no-undef
  let closable;

  before(async () => {
    closable = await Closable.new(getNow() + 10000);
  });

  describe('#Closable', () => {
    context('closes before created', () => {
      it('fails to create', async () => {
        await expectRevert(async () => await Closable.new(1));
      });
    });

    context('closes when created', () => {
      it('fails to create', async () => {
        await expectRevert(async () => await Closable.new(getNow()));
      });
    });

    context('closes after created', () => {
      it('fails to create', async () => {
        const closed = await closable.isClosed();
        expect(closed).to.be.false;
      });
    });
  });

  describe('isClosed', () => {
  });
});
