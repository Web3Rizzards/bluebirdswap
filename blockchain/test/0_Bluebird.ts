import 'dotenv/config';

import { BigNumber, BigNumberish } from 'ethers';
import { deployments, ethers } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { BBYC } from '../typechain/BBYC';
import { BluebirdOptions } from '../typechain/BluebirdOptions';
import { BluebirdGrinder } from '../typechain/BluebirdGrinder';
import { BluebirdManager } from '../typechain';
import { OptionPricing } from '../typechain';
import { BB20 } from '../typechain/BB20';
import { MockOracle } from '../typechain/MockOracle';
const { expect } = require('chai');

let owner: SignerWithAddress;
let user: SignerWithAddress;
let user2: SignerWithAddress;
let bluebirdOptions: BluebirdOptions;
let bluebirdGrinder: BluebirdGrinder;
let bluebirdManager: BluebirdManager;
let optionPricing: OptionPricing;
let bbyc: BBYC;
let bb20: BB20;
let mockOracle: MockOracle;

//// BluebirdGrinder

describe('BluebirdGrinder', function () {
  // Add your test cases.
  before(async () => {
    await deployments.fixture();
    [owner, user, user2] = await ethers.getSigners();
    // Get the deployed contract
    bluebirdGrinder = (await ethers.getContract('BluebirdGrinder')) as BluebirdGrinder;
    bbyc = (await ethers.getContract('BBYC')) as BBYC;
    // Mint 10 bbyc to user
    for (let i = 0; i < 10; i++) {
      await bbyc.connect(user).mint();
    }
    // Whitelist bbyc
    await bluebirdGrinder.whitelistNFT(bbyc.address);
    // Approve bbyc to bluebirdGrinder
    await bbyc.connect(user).setApprovalForAll(bluebirdGrinder.address, true);
  });
  it('Should fractionalise NFT', async () => {
    await bluebirdGrinder.connect(user).fractionalizeNFT(bbyc.address, 1);
    // Get address of newly deployed fractionalised token
    const bb20Address = await bluebirdGrinder.nftAddressToTokenAddress(bbyc.address);
    expect(bb20Address).to.not.equal('0x000000');
  });

  it('Should reconstruct NFT', async () => {
    const bb20Address = await bluebirdGrinder.nftAddressToTokenAddress(bbyc.address);
    bb20 = (await ethers.getContractAt('BB20', bb20Address)) as BB20;
    // Approve bb20 to bluebirdGrinder
    await bb20.connect(user).approve(bluebirdGrinder.address, ethers.constants.MaxUint256);
    await bluebirdGrinder.connect(user).reconstructNFT(bbyc.address, 1);
    expect(await bbyc.balanceOf(user.address)).to.equal(10);
  });
});

//// BluebirdManager
describe('BluebirdManager', function () {
  // Add your test cases.
  before(async () => {
    await deployments.fixture();
    [owner, user, user2] = await ethers.getSigners();
    // Get the deployed contract
    bluebirdGrinder = (await ethers.getContract('BluebirdGrinder')) as BluebirdGrinder;
    bluebirdManager = (await ethers.getContract('BluebirdManager')) as BluebirdManager;
    optionPricing = (await ethers.getContract('OptionPricing')) as OptionPricing;
    mockOracle = (await ethers.getContract('MockOracle')) as MockOracle;
    bbyc = (await ethers.getContract('BBYC')) as BBYC;
    // Mint 10 bbyc to user
    for (let i = 0; i < 10; i++) {
      await bbyc.connect(user).mint();
    }
    // Whitelist bbyc
    await bluebirdGrinder.whitelistNFT(bbyc.address);
    // Approve bbyc to bluebirdGrinder
    await bbyc.connect(user).setApprovalForAll(bluebirdGrinder.address, true);
  });
  // Test for all constant values
  it('Should create options', async () => {
    await bluebirdGrinder.connect(user).fractionalizeNFT(bbyc.address, 1);
    await bluebirdManager.createOptions(bbyc.address, mockOracle.address);
    expect((await bluebirdManager.getOptArray()).length).to.equal(1);
    // Get contract address of new optionsContract
    const optArray = await bluebirdManager.getOptArray();
    console.log('owner: ', owner.address);
    console.log('optArray: ', optArray[0]);
    bluebirdOptions = (await ethers.getContractAt('BluebirdOptions', optArray[0])) as BluebirdOptions;
    for (let i = 0; i < 6; i++) {
      console.log(await bluebirdOptions.nftOpts(i));
    }
  });
});
