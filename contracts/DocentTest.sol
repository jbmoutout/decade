// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract DocentTest is ERC721, ReentrancyGuard, Ownable {
  using Counters for Counters.Counter;

  constructor() ERC721("DocentTest", "DCT") {
  }

  /** MINTING **/

  Counters.Counter private supplyCounter;

  function mint(uint256 id) public payable nonReentrant {
    require(saleIsActive, "Sale not active");
    
    require(tokenPricesMap[id] > 0, "Price not set");

    require(msg.value >= tokenPricesMap[id], "Insufficient payment");

    _mint(msg.sender, id);

    supplyCounter.increment();
  }

  function totalSupply() public view returns (uint256) {
    return supplyCounter.current();
  }

  /** ACTIVATION **/

  bool public saleIsActive = false;

  function setSaleIsActive(bool saleIsActive_) external onlyOwner {
    saleIsActive = saleIsActive_;
  }

  /** TEST PRICE HANDLING **/

  mapping(uint256 => uint256) private tokenPricesMap;

  function setTokenPrice(uint256 tokenId, uint256 price_)
    external
    onlyOwner
  {
    tokenPricesMap[tokenId] = price_;
  }

  function setBatchTokenPrice(uint256[] memory tokenIds, uint256 price_)
    external
    onlyOwner
  {
     for (uint i = 0; i < tokenIds.length; i++) {
        tokenPricesMap[tokenIds[i]] = price_;
     }
  }

  function tokenPrice(uint256 tokenId) public view returns (uint256) {
      return tokenPricesMap[tokenId];
  }

  /** URI HANDLING **/

  string private customBaseURI;

  mapping(uint256 => string) private tokenURIMap;

  function setTokenURI(uint256 tokenId, string memory tokenURI_)
    external
    onlyOwner
  {
    tokenURIMap[tokenId] = tokenURI_;
  }

  function setBatchTokenURI(uint256[] memory tokenIds, string memory tokenURI_) external onlyOwner {
      for (uint i = 0; i < tokenIds.length; i++) {
          tokenURIMap[tokenIds[i]] = tokenURI_;
      }
  }

  function setBaseURI(string memory customBaseURI_) external onlyOwner {
    customBaseURI = customBaseURI_;
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return customBaseURI;
  }

  function tokenURI(uint256 tokenId) public view override
    returns (string memory)
  {
    string memory tokenURI_ = tokenURIMap[tokenId];

    if (bytes(tokenURI_).length > 0) {
      return tokenURI_;
    }

    return string(abi.encodePacked(super.tokenURI(tokenId)));
  }

  /** PAYOUT **/

  function withdraw() public nonReentrant {
    uint256 balance = address(this).balance;

    Address.sendValue(payable(owner()), balance);
  }
}