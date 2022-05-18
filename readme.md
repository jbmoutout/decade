##1 - COMPILE

SET VARIABLES (PRICE / MAX_SUPPLY / galleryAddress / artistAddress)

Compile Contracts in /contracts
`$ npx hardhat clean` (if contracts previously compiled)

`$ npx hardhat compile`

##2 - DEPLOY

Check .env for correct wallet & alechemy api key
Check .hardhat.config.js for correct network
Check scripts/helpers.js for correct network

Deploy contract

`$ npx hardhat deploy`

then add Contract Address to .env

##3 - VERIFY

Verify contract on etherscan.io

`$ npx hardhat verify --network NETWORK_NAME CONTRACT_ADDRESS `

##4 - ADD METADATA

Generate metadata
`$npx ipfs-car --pack metadata --output metadata.car`

Set metadata to contract
`$ npx hardhat set-metadata --metadata-url XXXXXX`

##5 - EXPORT ABI
`$npx hardhat export-abi --no-compile`
