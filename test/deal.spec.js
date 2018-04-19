const { expect } = require('chai');
const AlwaysValidator = artifacts.require('AlwaysValidator');
const NeverValidator = artifacts.require('NeverValidator');
const Deal = artifacts.require('Deal'); // eslint-disable-line no-undef

const expectRevert = async (func) => {
  try {
    await func();
    throw new Error('Should have failed');
  } catch ({message}) {
    expect(message).to.have.string('revert');
  }
};

const getNow = () => Math.round((new Date()).getTime() / 1000);

contract('Deal', (accounts) => { // eslint-disable-line no-undef
  const name = 'testDeal';
  const symbol = 'TDL';
  const granularity = 100;

  let mintStartTime;
  let holdStartTime;
  let transferStartTime;
  let deal = null;

  const createDeal = async (params = {}) => {
    const now = getNow();
    const {address: validatorAddress} = await AlwaysValidator.new();

    const normalized =
      Object.values({
        name,
        symbol,
        granularity,
        mintStartTime: now,
        holdStartTime: now + 100000,
        transferStartTime: now + 999999999,
        validatorAddress,
        ...params
      });

    return await Deal.new(...normalized);
  };

  beforeEach(async () => {
    deal = await createDeal();
  });

  describe('#Deal', () => {
    context('already ended', () => {
      it('fails to deploy', async () => {
        await expectRevert(async () => await createDeal({holdStartTime: mintStartTime + 1}));
      });
    });

    context('ends as soon as it begins', () => {
      it('fails to deploy', async () => {
        await expectRevert(async () => await createDeal({holdStartTime: mintStartTime}));
      });
    });

    context('ends before it begins', () => {
      it('fails to deploy', async () => {
        await expectRevert(async () => await createDeal({holdStartTime: mintStartTime - 1}));
      });
    });

    context('zero granularity', () => {
      it('fails to deploy', async () => {
        await expectRevert(async () => await createDeal({granularity: 0}));
      });
    });

    context('valid params', () => {
      it('deploys successfully', () => expect(deal).to.not.be.null);
    });
  });

  describe('#mint', () => {
    const [account] = accounts;
    const amount = 2 * granularity;

    context('during minting period', () => {
      beforeEach(async () => {
        await deal.mint(account, amount);
      });

      it(`increases the total supply by ${amount}`, async () => {
        const newTotal = await deal.totalSupply();
        expect(Number(newTotal)).to.equal(amount);
      });

      it(`increases the target user's balance by ${amount}`, async () => {
        const newBalance = await deal.balanceOf(account);
        expect(Number(newBalance)).to.equal(amount);
      });
    });

    context('before minting period', () => {
      it('prevents minting (revert)', async () => {
        const earlyDeal = await createDeal({mintStartTime: getNow() + 10000});
        await expectRevert(async () => await earlyDeal.mint(account, amount));
      });
    });

    context('after minting period', () => {
      it('prevents minting (revert)', async () => {
        const lateDeal = await createDeal({holdStartTime: getNow()});
        await expectRevert(async () => await lateDeal.mint(account, amount));
      });
    });

    context('user fails validation', () => {
      it('prevents minting (revert)', async () => {
        const { address: validatorAddress } = await NeverValidator.new();
        const neverOkDeal = await createDeal({validatorAddress});
        await expectRevert(async () => await neverOkDeal.mint(account, amount));
      });
    });
  });

  // describe('#canTransfer', () => {
  //   describe('', () => {
  //   });
  // });
});
