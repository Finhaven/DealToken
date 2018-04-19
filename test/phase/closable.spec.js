const { expect } = require('chai');
const { expectRevert, getNow } = require('../helpers');

const Closable = artifacts.require('Closable'); // eslint-disable-line no-undef

contract('Closable', () => { // eslint-disable-line no-undef
  let closesInFuture;

  before(async () => {
    closesInFuture = await Closable.new(getNow() + 100000);
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
      it('creates successfully', async () => {
        const closed = await closesInFuture.isClosed();
        return expect(closed).to.be.false;
      });
    });
  });

  describe('isClosed', () => {
    context('already closed', () => {
      it('is closed', async () => {
        const closable = await Closable.new(getNow() + 1);

        setTimeout(async () => {
          const closed = await closable.isClosed();
          return expect(closed).to.be.true;
        }, 10);
      });
    });

    context('not yet closed', () => {
      it('is closed', async () => {
        const closed = await closesInFuture.isClosed();
        return expect(closed).to.be.false;
      });
    });
  });
});
