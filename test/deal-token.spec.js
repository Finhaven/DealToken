const DealToken = artifacts.require('./DealToken.sol');

let dealToken;

const checkBalance = function (account, expected) {
  return () =>
    dealToken.balanceOf(account, { from: account })
      .then((balance) => {
        console.log('balance of token', balance);
        assert.equal(expected, balance.toNumber());
      });
};

const mintTokens = (account, amountToMint) =>
  () => {
    // const tx = { from: account, value: web3.utils.toWei('1', 'ether') };
    console.log('minting tokens ');
    return dealToken.mint(account, amountToMint)
      .then(() => dealToken.approve(account, amountToMint));
  };

const authorize = account =>
  () => dealToken.authorizeAddress(account, true);

const transfer = (from, to, amount, shouldFail) =>
  () => dealToken
    .transferFrom(from, to, amount)
    .then((result) => {
      if (shouldFail) {
        console.log('transfer success - should happen now', result);
        console.log('transfer logs ', JSON.stringify(result.logs));
        // should not reach this code
        assert.fail('transfer succeeded', 'transfer should fail');
      }
    })
    .catch(() => {
      // if transfer should fail this is ok
      if (!shouldFail) {
        // console.log('transfer failed', e);
        assert.fail('transfer failed', 'transfer should succeed');
      }
    });


contract('DealToken', (accounts) => {
  const account = accounts[0];

  beforeEach(async () => {
    dealToken = await DealToken.new();
  });

  it('should get instance of lp token', () => {
    assert.isNotNull(dealToken);
  });

  it('should get zero balance of lp token', () => checkBalance(account, 0));

  it('should mint tokens', () => Promise.resolve()
    .then(authorize(account))
    .then(checkBalance(account, 0))
    .then(mintTokens(account, 100))
    .then(checkBalance(account, 100)));

  it('should authorize transfer of tokens', () => Promise.resolve()
    .then(checkBalance(account, 0))
    .then(authorize(account))
    .then(mintTokens(account, 100)));

  it('should transfer tokens to authorized address', () => Promise.resolve()
    .then(checkBalance(account, 0))
    .then(authorize(account))
    .then(mintTokens(account, 100))
    .then(authorize(accounts[1]))
    .then(transfer(accounts[0], accounts[1], 50))
    .then(checkBalance(accounts[1], 50)));

  it('should not transfer tokens to an unauthorized address', () => {
    const shouldFail = true;
    return Promise.resolve()
      .then(checkBalance(account, 0))
      .then(authorize(account))
      .then(mintTokens(account, 100))
      .then(authorize(accounts[1]))
      .then(transfer(accounts[0], accounts[2], 50, shouldFail))
      .then(checkBalance(accounts[2], 0));
  });
});

