import 'dotenv/config';

module.exports = async ({ getNamedAccounts, deployments, getChainId }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // Chain Dependent Settings
  let contract = await deploy('OptionPricing', {
    from: deployer,
    args: [1000, 1],
  });
};

module.exports.tags = ['OptionPricing','All'];
