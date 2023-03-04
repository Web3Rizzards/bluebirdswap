import { BBYC } from '../typechain/BBYC';
import { Azuki } from '../typechain/Azuki';
import { BluebirdManager } from '../typechain/BluebirdManager';
import { BluebirdOptions } from '../typechain/BluebirdOptions';
import { MockOracle } from '../typechain/MockOracle';

import { ethers } from 'hardhat';

async function main() {
  // Get signer
  const signers = await ethers.getSigners();

  // Get contracts
  const manager = await ethers.getContract('BluebirdManager', signers[0]);
  const oracle = await ethers.getContract('MockOracle', signers[0]);
  const bbyc: BBYC = await ethers.getContract('BBYC', signers[0]);
  //const azuki: Azuki = await ethers.getContract('Azuki', signers[0]);
  // Real azuki address
  // await manager.createOptions(
  //   '0x570954E230BE1b093e6Ff64801337c3Bd7c5a7Fc',
  //   '0x9F6d70CDf08d893f0063742b51d3E9D1e18b7f74'
  // );
  // Mock BBYC address
  manager.createOptions(bbyc.address, oracle.address);
  // let optArray = await manager.getOptArray();
  // console.log('optArray: %s', optArray[0]);
  // // Using BluebirdOptions abi, get contract at speicfic address
  // const opt1: BluebirdOptions = await ethers.getContractAt('BluebirdOptions', optArray[0]);

  // // Loop through optArray and print
  // for (let i = 0; i < optArray.length; i++) {
  //   console.log('optArray[%s]: %s', i, optArray[i]);
  // }
  // await opt1.writeOption();
  //await bbyc.approve(opt1.address, ethers.utils.parseEther('1000000'));
  // \await opt1.depositNftToken(ethers.utils.parseEther('10000'));
  //await opt1.depositETH({ value: ethers.utils.parseEther('80300') });
  // let _getPremium = await opt1.getPremium(0);
  // console.log(_getPremium.toString());
  //console.log(_getPremium.toString());
  // await opt1.buy(0, ethers.utils.parseEther('20'){ value: _getPremium });
  // console.log(await opt1.nftOpts(0));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
