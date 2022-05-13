#1 - COMPILE

<!-- Compile Contracts in /contracts -->
<!-- $ npx hardhat clean (if contracts previously compiled)    -->

`$ npx hardhat compile`

#2 - DEPLOY

<!-- Check .env for correct wallet & alechemy api key -->
<!-- Check .hardhat.config.js for correct network -->
<!-- Check scripts/helpers.js for correct network -->
<!-- Deploy contract  -->

`$ npx hardhat deploy`

<!-- then add Contract Address to .env -->

#3 - VERIFY

<!-- Verify contract on etherscan.io -->

`$ npx hardhat verify --network NETWORK_NAME CONTRACT_ADDRESS `

#4 - SCRIPTS
