const AegisMarketing = artifacts.require("./AegisMarketing.sol")
const Token = artifacts.require("./Token.sol")

module.exports = async function(deployer, network, accounts) {
  // const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1 // one second in the future
  // const endTime = startTime + (86400 * 20) // 20 days
  // const rate = new web3.BigNumber(1000)
  // const wallet = accounts[0]



  deployer.deploy(Token,10000000000000).then(async() =>{
    var tokenc = await Token.deployed();
    deployer.deploy(AegisMarketing,web3.toChecksumAddress(tokenc.address)).then(async() =>{
      var marketerc = await AegisMarketing.deployed();
      tokenc.transfer(web3.toChecksumAddress(marketerc.address),123)
    })
  })
};
