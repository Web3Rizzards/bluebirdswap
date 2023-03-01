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
  let BBYC: Deployment | null;

  bluebirdFactory = await deployments.getOrNull('BluebirdFactory');
  bluebirdGrinder = await deployments.getOrNull('BluebirdGrinder');
  BBYC = await deployments.getOrNull('BBYC');

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
      name: 'BluebirdFactory.address',
      value: getAddress(bluebirdFactory),
      blockNumber: getBlockNumber(bluebirdFactory),
    },
    {
      name: 'BluebirdGrinder.address',
      value: getAddress(bluebirdGrinder),
      blockNumber: getBlockNumber(bluebirdGrinder),
    },
    { name: 'BBYC.address', value: getAddress(BBYC), blockNumber: getBlockNumber(BBYC) },
  ];

  console.table(entries);

  // Export Addresses and block numbers
  const addressAndBlockNumbers = {
    bluebird_factory_address: getAddress(bluebirdFactory),
    bluebird_factory_start_block: getBlockNumber(bluebirdFactory),
    bluebird_grinder_address: getAddress(bluebirdGrinder),
    bluebird_grinder_start_block: getBlockNumber(bluebirdGrinder),
    bbyc_address: getAddress(BBYC),
    bbyc_start_block: getBlockNumber(BBYC),
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

// module.exports.dependencies = ['Phase1'];
module.exports.tags = ['Setter'];
