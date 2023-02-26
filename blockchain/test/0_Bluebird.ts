import 'dotenv/config';

import { BigNumber, BigNumberish } from 'ethers';
import { deployments, ethers } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { Bluebird } from './../typechain/contracts/Bluebird';
import { BluebirdFaucet } from '../typechain';
import { BluebirdPrediction } from '../typechain/contracts/BluebirdPrediction';
import { MockUSDC } from '../typechain/contracts/MockUSDC';
const { expect } = require('chai');

let owner: SignerWithAddress;
let user: SignerWithAddress;
let user2: SignerWithAddress;
let bluebird: Bluebird;
let bluebirdFaucet: BluebirdFaucet;
let bluebirdPrediction: BluebirdPrediction;
let mockUSDC: MockUSDC;

describe('BluebirdPrediction', function () {
  // Add your test cases.
  before(async () => {
    await deployments.fixture();
    [owner, user, user2] = await ethers.getSigners();
    // Get the deployed contract
    bluebirdPrediction = (await ethers.getContract('BluebirdPrediction')) as BluebirdPrediction;
    bluebird = (await ethers.getContract('Bluebird')) as Bluebird;
    bluebirdFaucet = (await ethers.getContract('BluebirdFaucet')) as BluebirdFaucet;
    mockUSDC = (await ethers.getContract('MockUSDC')) as MockUSDC;
    // Whitelist users for faucet
    await bluebirdFaucet.connect(owner).whitelistAddresses([user.address, user2.address]);
    // Drip some tokens to the user
    await bluebirdFaucet.connect(user).drip();
    await bluebirdFaucet.connect(user2).drip();

    // Approve the contract to spend the user's tokens
    await bluebird.connect(user).approve(bluebirdPrediction.address, ethers.constants.MaxUint256);
    await bluebird.connect(user2).approve(bluebirdPrediction.address, ethers.constants.MaxUint256);

    // Approve the contract to spend the user's tokens
    await mockUSDC.connect(user).approve(bluebirdPrediction.address, ethers.constants.MaxUint256);
    await mockUSDC.connect(user2).approve(bluebirdPrediction.address, ethers.constants.MaxUint256);
  });
  // Test for all constant values
  it('Should take bull position', async () => {
    // Execute round
    await bluebirdPrediction.connect(owner).genesisStartRound();
    await bluebirdPrediction.connect(owner).genesisLockRound();
    // 5 mins pass
    await ethers.provider.send('evm_increaseTime', [300]);
    await ethers.provider.send('evm_mine', []);
    // Execute round
    await bluebirdPrediction.connect(owner).executeRound();
    let epoch = await bluebirdPrediction.currentEpoch();
    const amount = ethers.utils.parseUnits('100', 'ether');
    const tx = await bluebirdPrediction.connect(user).betBull(epoch.add(1), amount);
    const receipt = await tx.wait();
    const event = receipt.events?.find((e) => e.event === 'BetBull');
    const { amount: amountTaken } = event?.args;
    expect(amountTaken).to.equal(amount);
  });
});
