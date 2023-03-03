import { BBYC } from '../typechain/BBYC';
import { BluebirdManager } from '../typechain/BluebirdManager';
import { BluebirdOptions } from '../typechain/BluebirdOptions';

import { ethers } from 'hardhat';

async function main() {
  // Get signer
  const signers = await ethers.getSigners();

  // Get contracts
  const manager = await ethers.getContract('BluebirdManager', signers[0]);
  const bbyc: BBYC = await ethers.getContract('BBYC', signers[0]);
  let optArray = await manager.getOptArray();
  // Using BluebirdOptions abi, get contract at speicfic address
  const opt1: BluebirdOptions = await ethers.getContractAt('BluebirdOptions', optArray[0]);
  // Approve
  //await opt1.depositNftToken(ethers.utils.parseEther('1000'));
  let _getPremium = await opt1.getPremium(0);
  let historicalPrices = await opt1.getHistoricalPrices();
  for (let i = 0; i < historicalPrices.length; i++) {
    console.log('BBYC price day %s: %s', i, historicalPrices[i].toString());
  }
  //console.log(_getPremium.toString());
  await opt1.buy(0, { value: _getPremium });
  // console.log(await opt1.nftOpts(0));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
