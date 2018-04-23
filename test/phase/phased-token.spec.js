const { expect } = require('chai');
const { expectRevert, getNow } = require('../helpers');

const Phased = artifacts.require('PhasedToken'); // eslint-disable-line no-undef

contract('PhasedToken', () => { // eslint-disable-line no-undef
  let phased;

  let now = getNow();
  let mintStart = now;
  let holdStart = now + 10000;
  let transferStart = now + 999999;

  beforeEach(async () => {
    phased = await Phased.new(mintStart, holdStart, transferStart);
  });

  // describe('#constructor', () => {
  //   context('mint starts in the future', () => {
  //     context('hold after mint', () => {
  //       context('transfer after hold', () => {
  //         beforeEach(() => {
  //           now = getNow();
  //           mintStart = now + 1000;
  //           holdStart = now + 100000;
  //           transferStart = now + 9999999;
  //         });

  //         it('instantiates successfully', async () => {
  //           const phase = await phased.phase();
  //           console.log(">>>>>>>>>>>>>>>>");
  //           expect(phased).to.equal(9);
  //         });
  //       });
  //     });
  //   });
  // });
});
