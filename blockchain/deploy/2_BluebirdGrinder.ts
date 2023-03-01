import 'dotenv/config';

import { ethers } from 'hardhat';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy, read, execute } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // Chain Dependent Settings
  let contract = await deploy('BluebirdGrinder', {
    from: deployer,
    args: [],
    logs: true,
  });
};

module.exports.tags = ['BluebirdGrinder'];
