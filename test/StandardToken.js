// Zeppelin tests for ERC20 StandardToken. Run against Standard23Token to check full backwards compatibility.

const assertJump = require('./helpers/assertJump');
var StandardTokenMock = artifacts.require("./helpers/StandardTokenMock.sol");

const fixedSupply = 18666666667;

contract('Standard223Token', function(accounts) {

  it("should return the correct totalSupply after construction", async function() {
    let token = await StandardTokenMock.new(accounts[0], fixedSupply);
    let totalSupply = await token.totalSupply();

    assert.equal(totalSupply, fixedSupply);
  })

  it("should return the correct allowance amount after approval", async function() {
    let token = await StandardTokenMock.new(accounts[0], fixedSupply);
    let approve = await token.approve(accounts[1], 100);
    let allowance = await token.allowance(accounts[0], accounts[1]);

    assert.equal(allowance, 100);
  });

  it("should return correct balances after transfer", async function() {
    let token = await StandardTokenMock.new(accounts[0], 100);
    let transfer = await token.transfer(accounts[1], 100);
    let balance0 = await token.balanceOf(accounts[0]);
    assert.equal(balance0, 0);

    let balance1 = await token.balanceOf(accounts[1]);
    assert.equal(balance1, 100);
  });

  it("should throw an error when trying to transfer more than balance", async function() {
    let token = await StandardTokenMock.new(accounts[0], 100);
    try {
      console.log('try transfer');
      let transfer = await token.transfer(accounts[1], 101);
    } catch(error) {
        return;
    }
    assert.fail('should have thrown before');
  });

  it("should return correct balances after transfering from another account", async function() {
    let token = await StandardTokenMock.new(accounts[0], 100);
    let approve = await token.approve(accounts[1], 100);
    let transferFrom = await token.transferFrom(accounts[0], accounts[2], 100, {from: accounts[1]});

    let balance0 = await token.balanceOf(accounts[0]);
    assert.equal(balance0, 0);

    let balance1 = await token.balanceOf(accounts[2]);
    assert.equal(balance1, 100);

    let balance2 = await token.balanceOf(accounts[1]);
    assert.equal(balance2, 0);
  });

  it("should throw an error when trying to transfer more than allowed", async function() {
    let token = await StandardTokenMock.new(accounts[0], 100);
    let approve = await token.approve(accounts[1], 99);
    try {
      let transfer = await token.transferFrom(accounts[0], accounts[2], 100, {from: accounts[1]});
      //  function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
    } catch (error) {
      return true;
    }
    assert.fail('should have thrown before');
  });

});