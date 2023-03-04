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

  // // Mint BBYC
  // await (await bbyc.mint()).wait();

  // // Real azuki address
  // // await manager.createOptions(
  // //   '0x570954E230BE1b093e6Ff64801337c3Bd7c5a7Fc',
  // //   '0x9F6d70CDf08d893f0063742b51d3E9D1e18b7f74'
  // // );
  // // Mock BBYC address
  // // Whitelist BBYC in grinder, if not whitelisted
  // if ((await grinder.whitelisted(bbyc.address)) == false) await (await grinder.whitelistNFT(bbyc.address)).wait();

  // // Whitelist Azuki in grinder, if not whitelisted
  // if ((await grinder.whitelisted(azuki.address)) == false) await (await grinder.whitelistNFT(azuki.address)).wait();

  // // Create NFT tokens in grinder, if not created
  // if ((await grinder.nftAddressToTokenAddress(bbyc.address)) === ethers.constants.AddressZero)
  //   await (await grinder.createToken(bbyc.address)).wait();

  // // Create NFT tokens in grinder, if not created
  // if ((await grinder.nftAddressToTokenAddress(azuki.address)) === ethers.constants.AddressZero)
  //   await (await grinder.createToken(azuki.address)).wait();

  let optArray = await manager.getOptArray();
  // console.log(optArray);

  // if (optArray.length === 0) {
  //   await (await manager.createOptions(bbyc.address, oracle.address)).wait();
  //   await (await manager.createOptions(azuki.address, oracle.address)).wait();
  //   optArray = await manager.getOptArray();
  // }

  const opt1: BluebirdOptions = await ethers.getContractAt('BluebirdOptions', optArray[0]);
  const opt2: BluebirdOptions = await ethers.getContractAt('BluebirdOptions', optArray[1]);
  console.log('opt1: %s', opt1.address);
  console.log('opt2: %s', opt2.address);

  // await opt1.writeOption();
  // await (await opt2.writeOption()).wait();

  // ERROR: bbyc is the NFT, but it supposed to be bbBBYC
  const bbbbyc: BB20 = await ethers.getContractAt('BB20', await grinder.nftAddressToTokenAddress(bbyc.address));
  // approve bbyc to grinder
  // await (await bbyc.setApprovalForAll(grinder.address, true)).wait();
  // grind bbyc into bbbbyc tokens
  // await (await grinder.fractionalizeNFT(bbyc.address, 9)).wait();

  await bbbbyc.approve(opt1.address, ethers.utils.parseEther('1000000'));
  console.log(await opt1.getStage());
  if ((await opt1.getStage()).eq(0)) {
    await opt1.depositNftToken(ethers.utils.parseEther('10000'));
    await opt1.depositETH({ value: ethers.utils.parseEther('0.001') });
  }
  console.log('premium:');
  //TODO: ERROR FAILING HERE
  let premium = await opt1.getPremium(0);
  console.log(premium.toString());
  await opt1.buy(0, ethers.utils.parseEther('20'), { value: premium });
  console.log(await opt1.nftOpts(0));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
