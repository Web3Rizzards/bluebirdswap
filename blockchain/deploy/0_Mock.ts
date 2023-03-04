import 'dotenv/config';

import { ethers } from 'hardhat';
import { MockOracle } from '../typechain';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // await deploy('MockUSDC', {
  //   from: deployer,
  //   log: true,
  //   args: [],
  // });

  // await deploy('Azuki', {
  //   from: deployer,
  //   log: true,
  //   args: [],
  // });

  // await deploy('BAYC', {
  //   from: deployer,
  //   log: true,
  //   args: [],
  // });

  await deploy('BBYC', {
    from: deployer,
    log: true,
    args: [],
  });
  await deploy('MockOracle', {
    from: deployer,
    log: true,
    args: [ethers.utils.parseEther('16.3'), 18, 'Mock Oracle'],
  });

  // Get contract of MockOracle
  const mockOracle: MockOracle = await ethers.getContract('MockOracle', deployer);
  if ((await mockOracle.roundId()).lt(7)) {
    await mockOracle.setPrice(ethers.utils.parseEther('16.2'), { gasLimit: 1000000 });
    await mockOracle.setPrice(ethers.utils.parseEther('17.2'), { gasLimit: 1000000 });
    await mockOracle.setPrice(ethers.utils.parseEther('16.1'), { gasLimit: 1000000 });
    await mockOracle.setPrice(ethers.utils.parseEther('16.5'), { gasLimit: 1000000 });
    await mockOracle.setPrice(ethers.utils.parseEther('14.3'), { gasLimit: 1000000 });
    await mockOracle.setPrice(ethers.utils.parseEther('14.4'), { gasLimit: 1000000 });
    await mockOracle.setPrice(ethers.utils.parseEther('16.2'), { gasLimit: 1000000 });
  }
};

module.exports.tags = ['Mock','All'];
