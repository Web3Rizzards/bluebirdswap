import 'dotenv/config';
import { ethers } from 'hardhat';
module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy, read, execute } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // Chainlink Oracle Addresses
  const goerli_azuki = '0x9F6d70CDf08d893f0063742b51d3E9D1e18b7f74';

  // Get deployed contracts
  const bluebirdToken = await deployments.get('Bluebird');
  const _bluebirdTokenAddress = bluebirdToken.address;
  // Constructor Arguments
  const _oracleAddress = chainId === '80001' ? mumbai_eth_usd : polygon_eth_usd;
  const _adminAddress = deployer;
  const _operatorAddress = deployer;
  const _minBetAmount = ethers.utils.parseEther('0.01');
  const _oracleUpdateAllowance = 300;
  const _treasuryFee = 300;
  const _intervalSeconds = 300;
  const _bufferSeconds = 30;

  // Chain Dependent Settings
  let contract = await deploy('BluebirdPrediction', {
    from: deployer,
    args: [
      _bluebirdTokenAddress,
      _oracleAddress,
      _adminAddress,
      _operatorAddress,
      _intervalSeconds,
      _bufferSeconds,
      _minBetAmount,
      _oracleUpdateAllowance,
      _treasuryFee,
    ],
  });
};

module.exports.tags = ['BluebirdPrediction'];
