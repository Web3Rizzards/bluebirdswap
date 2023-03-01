import 'dotenv/config';

import { ethers } from 'hardhat';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  await deploy('MockUSDC', {
    from: deployer,
    log: true,
    args: [],
  });

  await deploy('BBYC', {
    from: deployer,
    log: true,
    args: [],
  });

  await deploy('MockOracle', {
    from: deployer,
    log: true,
    args: [ethers.utils.parseEther('100'), 18, 'Mock Oracle'],
  });
};

module.exports.tags = ['Mock'];
