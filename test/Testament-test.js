/* eslint-disable no-undef */
const { expect } = require('chai');

describe('Testament', function () {
  let Testament, testament, owner, alice;

  beforeEach(async function () {
    [dev, owner, alice, bob, charlie, dan, eve, doctor1, doctor2] = await ethers.getSigners();
    Testament = await ethers.getContractFactory('Testament');
    testament = await Testament.connect(owner).deploy(doctor1.address, alice.address);
    await testament.deployed();
  });
  describe('Deployement', function () {
    it('should affect address doctor to _doctor', async function () {
      expect(await testament.doctor()).to.equal(doctor1.address);
    });
  });
  describe('bequeath', function () {
    it('should increase alice balance of 5000', async function () {
      beforeAliceBalances = await testament.addressHeritageBalance(alice.address);
      await testament.connect(owner);
      await testament.bequeath(alice.address, { value: 5000, gasPrice: 0 });
      expect(await testament.addressHeritageBalance(alice.address)).to.equal(beforeAliceBalances.add(5000));
    });
  });
});

describe('TestamentFactory', function () {
  let TestamentFactory, testamentFactory, owner, alice, doctor;
  let testament1Address, tx;
  beforeEach(async function () {
    [deployer, owner, alice, bob, doctor, eve] = await ethers.getSigners();
    TestamentFactory = await ethers.getContractFactory('TestamentFactory');
    testamentFactory = await TestamentFactory.connect(owner).deploy();
    await testamentFactory.deployed();
    // compute testament1Address before deployment
    testament1Address = ethers.utils.getContractAddress({
      from: testamentFactory.address,
      nonce: await ethers.provider.getTransactionCount(testamentFactory.address),
    });
    // Deploy testament1
    tx = await testamentFactory.connect(owner).createTestament(doctor.address, alice.address);
  });
  it('should return beneficiary address for new contract created', async function () {
    expect(await testamentFactory.connect(owner).benificiary(testament1Address)).to.equal(alice.address);
  });
  it('Should emit a TestamentCreated event at deployment', async function () {
    await expect(tx).to.emit(testamentFactory, 'TestamentCreated')
      .withArgs(testament1Address, alice.address, doctor.address);
  });
});
