import 'dotenv/config';
import { ethers } from 'hardhat';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // Get deployed contracts
  const bluebirdToken = await deployments.get('Bluebird');
  const usdc = await deployments.get('MockUSDC');
  // Chain Dependent Settings
  let contract = await deploy('BluebirdFaucet', {
    from: deployer,
    args: [bluebirdToken.address, usdc.address],
  });
};

module.exports.tags = ['BluebirdFaucet'];
