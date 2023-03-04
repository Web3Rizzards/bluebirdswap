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
  const azuki: Azuki = await ethers.getContract('Azuki', signers[0]);
  let nftFeed = '0x9F6d70CDf08d893f0063742b51d3E9D1e18b7f74';
  // 1 time off
  // Minting
  //await bbyc.mint();
  // await azuki.mint();

  // // Approve
  //await bbyc.approve(grinder.address, 1);
  //await azuki.approve(grinder.address, 3);

  // // Grinder
  //await grinder.whitelistNFT(bbyc.address);
  // await grinder.whitelistNFT(azuki.address);

  // // Grind
  //await grinder.fractionalizeNFT(bbyc.address, 1);
  //await grinder.fractionalizeNFT(azuki.address, 3);

  let add = await grinder.nftAddressToTokenAddress(azuki.address);
  const bb20: BB20 = await ethers.getContractAt('BB20', add, signers[0]);
  // // Manager
  //await manager.createOptions(bbyc.address, oracle.address);
  //await manager.createOptions(azuki.address, nftFeed);
  let optArr = await manager.getOptArray();
  // // Get options contract at address
  const options: BluebirdOptions = await ethers.getContractAt('BluebirdOptions', optArr[0], signers[0]);

  //await options.setLiquidityProvidingTime(600);
  //await options.setInterval(1);

  // Options
  //await options.startEpoch();
  //await bb20.approve(options.address, ethers.utils.parseEther('100222234'));
  // await options.depositNftToken(ethers.utils.parseEther('100234'));
  // await options.depositETH({ value: ethers.utils.parseEther('0.0001') });
  //await options.writeOption();
  let premium = await options.getPremium(0);
  await options.buy(0, ethers.utils.parseEther('3232'), { value: premium });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
