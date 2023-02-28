import 'dotenv/config';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  await deploy('MockUSDC', {
    from: deployer,
    log: true,
    args: [],
  });

  await deploy('MockBBYC', {
    from: deployer,
    log: true,
    args: [],
  });
};

module.exports.tags = ['Mock'];
