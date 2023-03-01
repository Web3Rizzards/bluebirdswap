import 'dotenv/config';

import { BigNumber, BigNumberish } from 'ethers';
import { deployments, ethers } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { BBYC } from '../typechain/BBYC';
import { BluebirdOptions } from '../typechain/BluebirdOptions';
import { BluebirdGrinder } from '../typechain/BluebirdGrinder';
import { BluebirdManager } from '../typechain';
const { expect } = require('chai');

let owner: SignerWithAddress;
let user: SignerWithAddress;
let user2: SignerWithAddress;
let bluebirdOptions: BluebirdOptions;
let bluebirdGrinder: BluebirdGrinder;
let BluebirdManager: BluebirdManager;
let bbyc: BBYC;

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

    // Approve bbyc to bluebirdGrinder
    await bbyc.connect(user).setApprovalForAll(bluebirdGrinder.address, true);
  });
  // Test for all constant values
  it('Should fractionalise NFT', async () => {
    // Whitelist bbyc
    await bluebirdGrinder.whitelistNFT(bbyc.address);
    await bluebirdGrinder.connect(user).fractionalizeNFT(bbyc.address, 1);
    // Get address of newly deployed fractionalised token
    const bb20Address = await bluebirdGrinder.nftAddressToTokenAddress(bbyc.address);
    // Get bb20Address from bluebirdGrinder

    console.log(bb20Address);
  });
});

//// BluebirdManager
// describe('BluebirdManager', function () {
//   // Add your test cases.
//   before(async () => {
//     await deployments.fixture();
//     [owner, user, user2] = await ethers.getSigners();
//     // Get the deployed contract
//     bluebirdOptions = (await ethers.getContract('BluebirdOptions')) as BluebirdOptions;
//     bluebirdGrinder = (await ethers.getContract('BluebirdGrinder')) as BluebirdGrinder;
//     bluebirdFactory = (await ethers.getContract('BluebirdFactory')) as BluebirdFactory;
//     bb20 = (await ethers.getContract('BB20')) as BB20;
//     bbyc = (await ethers.getContract('BBYC')) as BBYC;
//   });
//   // Test for all constant values
//   it('Should create options', async () => {
//     await bluebirdGrinder.fractionalizeNFT();
//   });
// });
