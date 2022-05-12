const { task } = require("hardhat/config");
const { getContract } = require("./helpers");
const fetch = require("node-fetch");

task("mint", "Mints from the NFT contract")
.addParam("id", "The token id to mint")
.setAction(async function (taskArguments, hre) {
    const contract = await getContract("DocentTest", hre);
    const transactionResponse = await contract.mint(taskArguments.id, {
        gasLimit: 500_000,
        value: ethers.utils.parseEther("0.0001"),
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
});

task("activate-sale", "Make sale active")
.addParam("active", "Sale is active")
.setAction(async function (taskArguments, hre) {
    const contract = await getContract("DocentTest", hre);
    const transactionResponse = await contract.setSaleIsActive(taskArguments.active, {
        gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
});

task("setBatchPrices", "Set Price for the given tokens")
.addParam("tokenIds", "list of tokens")
.addParam("price", "the price")
.setAction(async function (taskArguments, hre) {
    console.log(taskArguments);
    const contract = await getContract("DocentTest", hre);
    const transactionResponse = await contract.setBatchTokenPrice(taskArguments.tokenIds, taskArguments.price, {
        gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
});

task("set-price", "Set Price for the given token")
.addParam("tokenId", "token")
.addParam("price", "the price")
.setAction(async function (taskArguments, hre) {
    console.log(taskArguments);
    const contract = await getContract("DocentTest", hre);
    const transactionResponse = await contract.setTokenPrice(taskArguments.tokenId, taskArguments.price, {
        gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
});
task("get-price", "Get Price for the given token")
.addParam("tokenId")
.setAction(async function (taskArguments, hre) {
    console.log(taskArguments);
    const contract = await getContract("DocentTest", hre);
    const transactionResponse = await contract.tokenPrice(taskArguments.tokenId, {
        gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
});

task("set-base-token-uri", "Sets the base token URI for the deployed smart contract")
.addParam("baseUrl", "The base of the tokenURI endpoint to set")
.setAction(async function (taskArguments, hre) {
    const contract = await getContract("DocentTest", hre);
    const transactionResponse = await contract.setBaseTokenURI(taskArguments.baseUrl, {
        gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
});

task("set-token-uri", "Sets the token URI for one TOKEN")
.addParam("tokenId", "Token id")
.addParam("tokenUri", "The tokenURI to set")
.setAction(async function (taskArguments, hre) {
    const contract = await getContract("DocentTest", hre);
    const transactionResponse = await contract.setTokenURI(taskArguments.tokenId, taskArguments.tokenUri, {
        gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
});


task("token-uri", "Fetches the token metadata for the given token ID")
.addParam("tokenId", "The tokenID to fetch metadata for")
.setAction(async function (taskArguments, hre) {
    const contract = await getContract("DocentTest", hre);
    const response = await contract.tokenURI(taskArguments.tokenId, {
        gasLimit: 500_000,
    });
    
    const metadata_url = response;
    console.log(`Metadata URL: ${metadata_url}`);

    const metadata = await fetch(metadata_url).then(res => res.json());
    console.log(`Metadata fetch response: ${JSON.stringify(metadata, null, 2)}`);
});
