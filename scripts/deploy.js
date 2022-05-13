const { task } = require('hardhat/config');
const { getAccount } = require('./helpers');

task('check-balance', 'Prints out the balance of your account').setAction(async function (
  taskArguments,
  hre
) {
  const account = getAccount();
  console.log(`Account balance for ${account.address}: ${await account.getBalance()}`);
});

task('deploy', 'Deploys the DOCENT contract').setAction(async function (taskArguments, hre) {
  const nftContractFactory = await hre.ethers.getContractFactory('CarlAndre', getAccount());
  const nft = await nftContractFactory.deploy();
  console.log(`Contract deployed to address: ${nft}`);
});
