// Include Tokens to deploy on Blockchain

const DappToken = artifacts.require('DappToken')
const DaiToken = artifacts.require('DaiToken')
const TokenFarm = artifacts.require('TokenFarm')

module.exports = async function(deployer, network, accounts) {
  //Deploy DAI Tokens to BN
  await deployer.deploy(DaiToken)
  const daiToken = await DaiToken.deployed()

  //Deploy Dapp Token to BN
  await deployer.deploy(DappToken)
  const dappToken = await DappToken.deployed()

  await deployer.deploy(TokenFarm, dappToken.address, daiToken.address)
  const tokenFarm = await TokenFarm.deployed()

  //Transfer all Dapp Tokens to tokenFarm (pool) 
  await dappToken.transfer(tokenFarm.address, '1000000000000000000000000') //1 million Dapp

  //Transfer 100 Mock/Fake DAI Tokens to investor
  await daiToken.transfer(accounts[1], '100000000000000000000') // 100 DAI
}
