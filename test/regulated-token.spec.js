const RegulatedToken = artifacts.require('./RegulatedToken.sol');

contract('RegulatedToken', () => {
  let regulatedToken;

  beforeEach(async () => {
    regulatedToken = await RegulatedToken.new();
  });

  it('should get instance of regulated', () => {
    console.log('regulatedToken address', regulatedToken.address);
    assert.isNotNull(regulatedToken);


    // })
    // .then(token => {
    //   // console.log('token address', token);
    //   return  regulatedToken.balanceOf.call(accounts[0], {from: accounts[0]});
    // })
    // .then(balance => {
    //   console.log('balance of token', balance.toNumber());
    //   assert.equal(0, balance.toNumber());
    // })
    // .then(() => {
    //   let tx = {from: accounts[0], value: web3.utils.toWei('1', 'ether')};
    //   console.log('sending transaction', tx);
    //   return regulatedToken.mint(accounts[0],1000);
    // })
    // .then((sendResult) => {
    //   console.log('send result', sendResult);
    //   return regulatedToken.balanceOf.call(accounts[0], {from: accounts[0]});
    // })
    // .then(balance => {
    //   console.log('balance of token after', balance.toNumber());
    //   // assert.equal(web3.utils.toWei(1000, 'ether'), balance.toNumber());
    // })
    // .catch(e => {
    //   console.error('test fail', e);
    //   return Promise.reject(e);
    // });
  });
});

