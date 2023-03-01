import 'dotenv/config';

import { BigNumber, BigNumberish } from 'ethers';
import { deployments, ethers } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { BB20 } from '../typechain/BB20';
import { BBYC } from '../typechain/BBYC';
import { BluebirdOptions } from '../typechain/BluebirdOptions';
import { BluebirdGrinder } from '../typechain/BluebirdGrinder';
import { BluebirdFactory } from '../typechain/BluebirdFactory';
const { expect } = require('chai');

let owner: SignerWithAddress;
let user: SignerWithAddress;
let user2: SignerWithAddress;
let bluebirdOptions: BluebirdOptions;
let bluebirdGrinder: BluebirdGrinder;
let bluebirdFactory: BluebirdFactory;
let bb20: BB20;
let bbyc: BBYC;

describe('Bluebird', function () {
  // Add your test cases.
  before(async () => {
    await deployments.fixture();
    [owner, user, user2] = await ethers.getSigners();
    // Get the deployed contract
    bluebirdOptions = (await ethers.getContract('BluebirdOptions')) as BluebirdOptions;
    bluebirdGrinder = (await ethers.getContract('BluebirdGrinder')) as BluebirdGrinder;
    bluebirdFactory = (await ethers.getContract('BluebirdFactory')) as BluebirdFactory;
    bb20 = (await ethers.getContract('BB20')) as BB20;
    bbyc = (await ethers.getContract('BBYC')) as BBYC;
  });
  // Test for all constant values
  it('Should create options', async () => {
    await bluebirdGrinder.fractionalizeNFT();
  });
});
