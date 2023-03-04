import { Contract } from 'ethers';
import { Deployment } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { ethers } from 'hardhat';
import fs from 'fs';
import path from 'path';

/**
 * This deployment file will help to check for changes and set the address of the new contract
 */

module.exports = async ({ getNamedAccounts, deployments, getChainId, network }: HardhatRuntimeEnvironment) => {
  const { deploy, execute, read } = deployments;

  const { deployer } = await getNamedAccounts();
  console.log('Deployer: ', deployer);
  const chainId = await getChainId();
  let networkName = network.name.replace('_', '-');
  if (networkName == 'hardhat') {
    networkName = 'localhost';
  }

  console.log(network.name);

  let bluebirdFactory: Deployment | null;
  let bluebirdGrinder: Deployment | null;
  let bluebirdManager: Deployment | null;
  let BBYC: Deployment | null;
  let azuki: Deployment | null;

  bluebirdFactory = await deployments.getOrNull('BluebirdFactory');
  bluebirdGrinder = await deployments.getOrNull('BluebirdGrinder');
  bluebirdManager = await deployments.getOrNull('BluebirdManager');
  BBYC = await deployments.getOrNull('BBYC');
  azuki = await deployments.getOrNull('Azuki');

  function getAddress(contract: Deployment | Contract | null) {
    if (contract) {
      return contract.address;
    }
    return '';
  }

  function getBlockNumber(contract: Deployment | Contract | null) {
    if (contract) {
      if (contract.receipt) return contract.receipt.blockNumber;
    }
    return '';
  }

  const entries = [
    {
      name: 'BluebirdGrinder.address',
      value: getAddress(bluebirdGrinder),
      blockNumber: getBlockNumber(bluebirdGrinder),
    },
    {
      name: 'BluebirdManager.address',
      value: getAddress(bluebirdManager),
      blockNumber: getBlockNumber(bluebirdManager),
    },
    { name: 'BBYC.address', value: getAddress(BBYC), blockNumber: getBlockNumber(BBYC) },
    { name: 'Azuki.address', value: getAddress(azuki), blockNumber: getBlockNumber(azuki) },
  ];

  console.table(entries);

  // Export Addresses and block numbers
  const addressAndBlockNumbers = {
    bluebird_grinder_address: getAddress(bluebirdGrinder),
    bluebird_grinder_start_block: getBlockNumber(bluebirdGrinder),
    bluebird_manager_address: getAddress(bluebirdManager),
    bluebird_manager_start_block: getBlockNumber(bluebirdManager),
    bbyc_address: getAddress(BBYC),
    bbyc_start_block: getBlockNumber(BBYC),
    azuki_address: getAddress(azuki),
    azuki_start_block: getBlockNumber(azuki),
  };

  // Read config file from subgraph/packages/config
  const config = JSON.parse(
    fs.readFileSync(
      path.join(__dirname, '..', '..', 'subgraph', 'packages', 'config', 'src', `${networkName}.json`),
      'utf8'
    )
  );

  const atlantisConfig = {
    ...config,
    ...addressAndBlockNumbers,
  };

  fs.writeFileSync(
    path.join(__dirname, '..', '..', 'subgraph', 'packages', 'config', 'src', `${networkName}.json`),
    JSON.stringify(atlantisConfig, null, 2)
  );
};

module.exports.tags = ['Setter','All'];
