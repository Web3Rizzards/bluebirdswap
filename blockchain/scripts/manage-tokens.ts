import { BB20 } from '../typechain/BB20';
import { BBYC } from '../typechain/BBYC';
import { BluebirdGrinder } from '../typechain/BluebirdGrinder';
import { ethers } from 'hardhat';

async function main() {
  // Get signer
  const signers = await ethers.getSigners();

  // Get contracts
  // const bb20: BB20 = await ethers.getContract('BB20', signers[0]);
  const grinder: BluebirdGrinder = await ethers.getContract('BluebirdGrinder', signers[0]);
  const bbyc: BBYC = await ethers.getContract('BBYC', signers[0]);
  const collectionAddresses = [bbyc.address];
  let tokenAddresses = [];
  // Get address of BBYC token
  for (let i = 0; i < collectionAddresses.length; i++) {
    tokenAddresses.push(await grinder.getTokenFromCollection(collectionAddresses[i]));
    console.log(tokenAddresses[i]);
  }
  // Using BB20 abi, get contract at speicfic address
  const bb20: BB20 = await ethers.getContractAt('BB20', tokenAddresses[0]);
  // Approve
  await bb20.approve('0x75594F7f6C8c63F2a3a35D4F10E5fE16582253b1', ethers.utils.parseEther('10000000'));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
