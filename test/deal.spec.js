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

  const [account] = accounts;
  const [to, from] = accounts;
  const amount = 2 * granularity;

  let mintStartTime;
  let holdStartTime;
  let transferStartTime;

  let alwaysValidator;
  let neverValidator;
  let validatorAddress;

  let deal = null;
  let neverDeal;

  const createDeal = async (params = {}) => {
    const now = getNow();
    mintStartTime = now;
    holdStartTime = now + 100000;
    transferStartTime = now + 999999999;

    const normalized =
      Object.values({
        name,
        symbol,
        granularity,
        mintStartTime,
        holdStartTime,
        transferStartTime,
        validatorAddress: null,
        ...params
      });

    return await Deal.new(...normalized);
  };

  before(async () => {
    alwaysValidator = await AlwaysValidator.new();
    validatorAddress = alwaysValidator.address;
    deal = await createDeal({validatorAddress});

    neverValidator = await NeverValidator.new();
    neverDeal = await createDeal({validatorAddress: neverValidator.address});
  });

  describe('#Deal', () => {
    context('already ended', () => {
      const holdStartTime = mintStartTime + 1;

      it('fails to create', async () => {
        await expectRevert(async () => await createDeal({validatorAddress, holdStartTime}));
      });
    });

    context('ends as soon as it begins', () => {
      const holdStartTime = mintStartTime;

      it('fails to create', async () => {
        await expectRevert(async () => await createDeal({validatorAddress, holdStartTime}));
      });
    });

    context('ends before it begins', () => {
      const holdStartTime = mintStartTime - 1;

      it('fails to create', async () => {
        await expectRevert(async () => await createDeal({validatorAddress, holdStartTime}));
      });
    });

    context('zero granularity', () => {
      it('fails to create', async () => {
        await expectRevert(async () => await createDeal({validatorAddress, granularity: 0}));
      });
    });

    context('valid params', () => {
      it('deploys successfully', () => expect(deal).to.not.be.null);
    });
  });

  describe('#mint', () => {
    context('during minting period', () => {
      let initialBalance = 0;
      let initialSupply = 0;

      beforeEach(async () => {
        initialBalance = Number(await deal.balanceOf(account));
        initialSupply = Number(await deal.totalSupply());
        await deal.mint(account, amount);
      });

      it(`increases the total supply by ${amount}`, async () => {
        const newTotal = await deal.totalSupply();
        expect(Number(newTotal)).to.equal(initialBalance + amount);
      });

      it(`increases the target user's balance by ${amount}`, async () => {
        const newBalance = await deal.balanceOf(account);
        expect(Number(newBalance)).to.equal(initialBalance + amount);
      });
    });

    context('before minting period', () => {
      it('prevents minting (revert)', async () => {
        const earlyDeal = await createDeal({validatorAddress, mintStartTime: getNow() + 10000});
        await expectRevert(async () => await earlyDeal.mint(account, amount));
      });
    });

    context('after minting period', () => {
      it('prevents minting (revert)', async () => {
        const lateDeal = await createDeal({validatorAddress, holdStartTime: getNow()});
        await expectRevert(async () => await lateDeal.mint(account, amount));
      });
    });

    context('user fails validation', () => {
      it('prevents minting (revert)', async () => {
        await expectRevert(async () => await neverDeal.mint(account, amount));
      });
    });
  });

  describe('#transfer', () => {
    // context('during transfer phase', () => {
    //   let transferDeal;

    //   beforeEach(async() => {
    //     const now = getNow();

    //     transferDeal = await createDeal({
    //       validatorAddress: alwaysValidator.address,
    //       mintStartTime: now - 10000,
    //       holdStartTime: now - 100,
    //       transferStartTime: now - 10
    //     });

    //     await transferDeal.mint(from, amount);
    //     await transferDeal.transferFrom(from, to, amount);
    //   });

    //   it('transfers successfully', async () => {
    //     const balance = await transferDeal.balanceOf(to);
    //     expect(Number(balance)).to.equal(amount);
    //   });
    // });

    context('not during transfer phase', () => {
      it('does not allow transfer', async () => {
        await expectRevert(async () => await deal.transferFrom(to, from, amount));
      });
    });

    context('fails validation', () => {
      it('reverts', async () => {
        await expectRevert(async () => await neverDeal.transferFrom(to, from, amount));
      });
    });
  });
});
