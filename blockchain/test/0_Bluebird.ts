import 'dotenv/config';

import { BB20, BBYC, BluebirdGrinder, BluebirdManager, BluebirdOptions, MockOracle, OptionPricing } from '../typechain';
import { BigNumber, BigNumberish } from 'ethers';
import { deployments, ethers } from 'hardhat';

import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';

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
    for (let i = 0; i < 10; i++) {
      await bbyc.connect(user2).mint();
    }
    // Whitelist bbyc
    await bluebirdGrinder.whitelistNFT(bbyc.address);
    // Approve bbyc to bluebirdGrinder
    await bbyc.connect(user).setApprovalForAll(bluebirdGrinder.address, true);
    await bbyc.connect(user2).setApprovalForAll(bluebirdGrinder.address, true);
  });
  // Test for all constant values
  it('Should create options', async () => {
    await bluebirdGrinder.connect(user).fractionalizeNFT(bbyc.address, 1);
    await bluebirdGrinder.connect(user2).fractionalizeNFT(bbyc.address, 11);

    await (await bluebirdManager.createOptions(bbyc.address, mockOracle.address)).wait();

    expect((await bluebirdManager.getOptArray()).length).to.equal(1);
    // Get contract address of new optionsContract
    const optArray = await bluebirdManager.getOptArray();
    bluebirdOptions = (await ethers.getContractAt('BluebirdOptions', optArray[0])) as BluebirdOptions;
    await bluebirdOptions.startEpoch();

    let optionContract = await bluebirdOptions.nftOpts(0);
    console.log('🚀 | it | optionContract:', optionContract);
    console.log('strikePrice: ', optionContract.strike.toString());

    const liquidityProviderTime = await bluebirdOptions.liquidityProvidingTime();
    const bb20Address = await bluebirdGrinder.nftAddressToTokenAddress(bbyc.address);
    bb20 = (await ethers.getContractAt('BB20', bb20Address)) as BB20;
    await bb20.connect(user2).approve(bluebirdOptions.address, ethers.constants.MaxUint256);
    await bb20.connect(user).approve(bluebirdOptions.address, ethers.constants.MaxUint256);
    console.log('Initial price of NFT: 100 ETH');
    await bluebirdOptions.connect(user2).depositNftToken(ethers.utils.parseEther('1000'));
    console.log('User 2 deposits 1000 nft tokens');
    await bluebirdOptions.connect(user2).depositETH({ value: ethers.utils.parseEther('3000') });
    console.log('User 2 deposits 3000 ETH');
    // Wait 30 seconds
    await ethers.provider.send('evm_increaseTime', [300]);
    // Write options
    await bluebirdOptions.writeOption();
    await bluebirdOptions.setInterval(1);
    console.log(await bluebirdOptions.getHistoricalPrices());
    let _getPremium = await bluebirdOptions.getPremium(0, ethers.utils.parseEther('200'));
    console.log('Premium for 200 nft tokens: ', _getPremium.toString());
    console.log('Premium for 200 nft tokens: ', ethers.utils.formatEther(_getPremium));
    _getPremium = await bluebirdOptions.getPremium(0, ethers.utils.parseEther('100'));
    console.log('Premium for 100 nft tokens: ', _getPremium.toString());
    console.log('Premium for 100 nft tokens: ', ethers.utils.formatEther(_getPremium));
    console.log(
      'Fractionalised NFT token balance of user at the start: ',
      (await bb20.balanceOf(user.address)).toString()
    );
    console.log("User's ETH balance at the start: ", (await user.getBalance()).toString());

    await bluebirdOptions.connect(user).buy(0, ethers.utils.parseEther('200'));
    console.log(
      'Fractionalised NFT token balance of user after buying call option 1 time: ',
      (await bb20.balanceOf(user.address)).toString()
    );
    console.log("User's ETH balance after buying call option 1 time: ", (await user.getBalance()).toString());

    // One week passes
    await ethers.provider.send('evm_increaseTime', [604800]);
    console.log('One week passes');
    // Set price on oracle
    await mockOracle.setPrice(ethers.utils.parseEther('20'));

    console.log('Floor price of NFT increases to 20 ETH');
    // Calculate amountETH
    const amountETH = await bluebirdOptions.connect(user).calculateAmountETH(0);
    console.log('AmountETH: ', amountETH.toString());
    // Try to exercise
    await bluebirdOptions.connect(user).exercise(0, { value: amountETH });
    console.log(
      'Fractionalised NFT token balance of user after exercising call option: ',
      (await bb20.balanceOf(user.address)).toString()
    );
    console.log("User's ETH balance after exercising call option: ", (await user.getBalance()).toString());
  });

  it('Should return correct info from mockOracle', async () => {
    console.log(await mockOracle.latestRoundData());
    console.log(await mockOracle.getRoundData(2));
  });
});
