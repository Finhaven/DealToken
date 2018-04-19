const expectRevert = async (func) => {
  try {
    await func();
    throw new Error('Should have failed');
  } catch ({message}) {
    expect(message).to.have.string('revert');
  }
};

const getNow = () => Math.round((new Date()).getTime() / 1000);

module.exports = {
  expectRevert,
  getNow
};
