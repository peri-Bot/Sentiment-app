const { network } = require("hardhat")
const { networkConfig, developmnetChain } = require("../helper-hardhat.config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()

    const marketsentiment = await deploy("MarketSentiment", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developmnetChain.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(marketsentiment.address)
    }
    log("=========================================")
}
module.exports.tags = ["all", "marketsentiment"]
