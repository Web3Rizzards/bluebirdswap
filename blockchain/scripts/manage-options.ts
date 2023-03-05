import { ethers } from 'hardhat';
import { BluebirdGrinder, BBYC, Azuki, BluebirdManager, BluebirdOptions, MockOracle, BB20 } from '../typechain';

async function main() {
  // Get signer
  const signers = await ethers.getSigners();

  // Get contracts
  const manager: BluebirdManager = await ethers.getContract('BluebirdManager', signers[0]);
  const grinder: BluebirdGrinder = await ethers.getContract('BluebirdGrinder', signers[0]);
  const oracle: MockOracle = await ethers.getContract('MockOracle', signers[0]);
  const bbyc: BBYC = await ethers.getContract('BBYC', signers[0]);
  //const azuki: Azuki = await ethers.getContract('Azuki', signers[0]);
  let nftFeed = '0x9F6d70CDf08d893f0063742b51d3E9D1e18b7f74';
  // 1 time off
  // Minting
  //await bbyc.mint();
  // await azuki.mint();

  // // Approve
  // await bbyc.approve(grinder.address, 1);
  // await azuki.approve(grinder.address, 5);

  // // Grinder
  // await grinder.whitelistNFT(bbyc.address);
  // await grinder.whitelistNFT(azuki.address);

  // // Grind
  //await grinder.fractionalizeNFT(bbyc.address, 1);
  // await grinder.fractionalizeNFT(azuki.address, 5);

  let add = await grinder.nftAddressToTokenAddress(bbyc.address);
  const bb20: BB20 = await ethers.getContractAt('BB20', add, signers[0]);
  // Manager
  // await manager.createOptions(bbyc.address, oracle.address);
  // await manager.createOptions(azuki.address, nftFeed);
  let optArr = await manager.getOptArray();
  // // // // Get options contract at address
  const options: BluebirdOptions = await ethers.getContractAt('BluebirdOptions', optArr[1], signers[0]);

  await options.setLiquidityProvidingTime(120);
  await options.setExpiry(300);
  //await options.setLiquidityProvidingTime(100);
  // await options.setInterval(1);

  //await options.depositNftToken(ethers.utils.parseEther('52132'));
  // await oracle.setPrice(ethers.utils.parseEther('16.5'));
  while (true) {
    // For calls only
    console.log('Epoch: ', (await options.epoch()).toString());
    console.log('Expiry: ', (await options.EXPIRY()).toString());
    console.log('Stage:', (await options.getStage()).toString());
    console.log('Liquidity providing time: ', (await options.liquidityProvidingTime()).toString());
    console.log('Starting epoch.. ');
    await options.startEpoch();
    // Sleep for 145 seconds
    await new Promise((r) => setTimeout(r, 165000));
    console.log('Writing option..');
    await options.writeOption();
    // Sleep for 215 seconds
    await new Promise((r) => setTimeout(r, 115000));
    console.log('Setting price to 19.5 to simulate price increase..');
    await oracle.setPrice(ethers.utils.parseEther('19.5'));
    // Sleep for 30 seconds
    await new Promise((r) => setTimeout(r, 150000));
    console.log('Resetting price...');
    await oracle.setPrice(ethers.utils.parseEther('16.5'));
    // Sleep for 60 seconds
    await new Promise((r) => setTimeout(r, 60000));
  }

  //await options.writeOption();
  //await options.writeOption();
  // Options
  //await options.startEpoch();
  // await bb20.approve(options.address, ethers.utils.parseEther('100222234'));
  // await options.depositNftToken(ethers.utils.parseEther('32134'));
  // await options.depositETH({ value: ethers.utils.parseEther('0.0001') });
  //await options.writeOption();
  // let premium = await options.getPremium(2);
  //await options.buy(28, ethers.utils.parseEther('240'));
  // await options.exercise(14);
  //console.log(bb20.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
