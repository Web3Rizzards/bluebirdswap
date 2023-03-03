import 'dotenv/config';

import { ethers } from 'hardhat';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // Get Options Pricing
  let optionsPricing = await deployments.get('OptionPricing');
  let grinder = await deployments.get('BluebirdGrinder');

  // Chain Dependent Settings
  let contract = await deploy('BluebirdManager', {
    from: deployer,
    args: [optionsPricing.address, grinder.address],
    logs: true,
  });
};

module.exports.tags = ['BluebirdManager'];
