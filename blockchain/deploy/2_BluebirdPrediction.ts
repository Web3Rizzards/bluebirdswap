import 'dotenv/config';
import { ethers } from 'hardhat';
module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy, read, execute } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // Chainlink Oracle Addresses
  const mumbai_eth_usd = '0x0715A7794a1dc8e42615F059dD6e406A6594651A';
  const polygon_eth_usd = '0xF9680D99D6C9589e2a93a78A04A279e509205945';
  const ethereum_eth_usd = '0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419';
  const goerli_eth_usd = '0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e';

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
