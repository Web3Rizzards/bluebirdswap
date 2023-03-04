import {
  BluebirdGrinder,
  BBYC,
  Azuki,
  BluebirdManager,
  BluebirdOptions,
  MockOracle,
  OptionPricing,
} from '../typechain';

import { ethers } from 'hardhat';

async function main() {
  // Get signer
  const signers = await ethers.getSigners();

  // Get contracts
  const manager: BluebirdManager = await ethers.getContract('BluebirdManager', signers[0]);
  const azuki: Azuki = await ethers.getContract('Azuki', signers[0]);
  const bbyc: BBYC = await ethers.getContract('BBYC', signers[0]);
  //  const bayc: BAYC = await ethers.getContract('BAYC', signers[0]);
  const oracle: MockOracle = await ethers.getContract('MockOracle', signers[0]);
  const grinder: BluebirdGrinder = await ethers.getContract('BluebirdGrinder', signers[0]);
  const optionPricing: OptionPricing = await ethers.getContract('OptionPricing', signers[0]);
  let optArray = await manager.getOptArray();
  // Log all addresses
  console.log('manager: %s', manager.address);
  console.log('azuki: %s', azuki.address);
  console.log('bbyc: %s', bbyc.address);
  //  console.log('bayc: %s', bayc.address);
  console.log('oracle: %s', oracle.address);
  console.log('grinder: %s', grinder.address);
  console.log('optionPricing: %s', optionPricing.address);
  for (let i = 0; i < optArray.length; i++) {
    console.log('Options contract: %s', i, optArray[i]);
  }
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
