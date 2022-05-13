// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/interfaces/IERC2981.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/Address.sol';

/** 
                                                                     ,----, 
                 ,----..                                 ,--.      ,/   .`| 
    ,---,       /   /   \    ,----..      ,---,.       ,--.'|    ,`   .'  : 
  .'  .' `\    /   .     :  /   /   \   ,'  .' |   ,--,:  : |  ;    ;     / 
,---.'     \  .   /   ;.  \|   :     :,---.'   |,`--.'`|  ' :.'___,/    ,'  
|   |  .`\  |.   ;   /  ` ;.   |  ;. /|   |   .'|   :  :  | ||    :     |   
:   : |  '  |;   |  ; \ ; |.   ; /--` :   :  |-,:   |   \ | :;    |.';  ;   
|   ' '  ;  :|   :  | ; | ';   | ;    :   |  ;/||   : '  '; |`----'  |  |   
'   | ;  .  |.   |  ' ' ' :|   : |    |   :   .''   ' ;.    ;    '   :  ;   
|   | :  |  ''   ;  \; /  |.   | '___ |   |  |-,|   | | \   |    |   |  '   
'   : | /  ;  \   \  ',  / '   ; : .'|'   :  ;/|'   : |  ; .'    '   :  |   
|   | '` ,/    ;   :    /  '   | '/  :|   |    \|   | '`--'      ;   |.'    
;   :  .'       \   \ .'   |   :    / |   :   .''   : |          '---'      
|   ,.'          `---`      \   \ .'  |   | ,'  ;   |.'                     
'---'                        `---`    `----'    '---'                       
                                                                            
**/

contract CarlAndreDocent is ERC721, IERC2981, ReentrancyGuard, ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;

  // Constants
  uint256 public constant MAX_SUPPLY = 30;
  uint256 public constant PRICE = 20000000000000000; /// 0.02 ETH

  address private constant galleryAddress = 0xd7E8D1a3534CDa62C6574309D8100c1c7B52241c;
  address private constant artistAddress = 0x51893553130B4468c22694fA7434cF05b03CCE41;

  constructor() ERC721('CarlAndreDocent', 'DCNT') {}

  /** MINTING **/

  Counters.Counter private supplyCounter;

  string private metadataURI;

  function mint(uint256 tokenId) public payable nonReentrant {
    require(saleIsActive, 'Sale not active');

    require(totalSupply() < MAX_SUPPLY, 'Exceeds max supply');

    require(msg.value >= PRICE, 'Insufficient payment');

    require(bytes(metadataURI).length != 0, 'Metadata not set');

    _safeMint(msg.sender, tokenId);

    _setTokenURI(tokenId, metadataURI);

    supplyCounter.increment();
  }

  function totalSupply() public view returns (uint256) {
    return supplyCounter.current();
  }

  /** ACTIVATION **/

  bool public saleIsActive = true;

  function setSaleIsActive(bool saleIsActive_) external onlyOwner {
    saleIsActive = saleIsActive_;
  }

  /** METADATA **/

  function setMetadataURI(string memory metadataURI_) external onlyOwner {
    metadataURI = metadataURI_;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
  {
    return super.tokenURI(tokenId);
  }

  /** PAYOUT **/

  function withdraw() public nonReentrant {
    uint256 balance = address(this).balance;

    Address.sendValue(payable(owner()), (balance * 40) / 100);

    Address.sendValue(payable(galleryAddress), (balance * 30) / 100);

    Address.sendValue(payable(artistAddress), (balance * 30) / 100);
  }

  /** ROYALTIES **/

  function royaltyInfo(uint256, uint256 salePrice)
    external
    view
    override
    returns (address receiver, uint256 royaltyAmount)
  {
    return (address(this), (salePrice * 1000) / 10000);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721, IERC165)
    returns (bool)
  {
    return (interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId));
  }

  // The following functions are overrides required by Solidity.

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }
}

// Forked from Studio 721
// https://721.so
