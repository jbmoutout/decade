// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

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

contract CarlAndre is ERC721, IERC2981, ReentrancyGuard, Ownable {
  using Counters for Counters.Counter;

  // Constants
  uint256 public constant MAX_SUPPLY = 30;
  uint256 public constant PRICE = 20000000000000000; /// 0.02 ETH

  address private constant galleryAddress =
    0xd7E8D1a3534CDa62C6574309D8100c1c7B52241c;

  address private constant artistAddress =
    0x51893553130B4468c22694fA7434cF05b03CCE41;


  /// @dev Base token URI used as a prefix by tokenURI().
  string public baseTokenURI;

  constructor() ERC721("CarlAndre", "DCNT") {
    baseTokenURI = "";
  }

  /** MINTING **/

  Counters.Counter private supplyCounter;

  function mint(uint256 tokenId) public payable nonReentrant {
    require(saleIsActive, "Sale not active");

    require(totalSupply() < MAX_SUPPLY, "Exceeds max supply");

    require(msg.value >= PRICE, "Insufficient payment, 0.02 ETH per artwork");

    _safeMint(msg.sender, tokenId);

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

  /** URI HANDLING **/

  string private customBaseURI;

  function setBaseURI(string memory baseTokenURI_) external onlyOwner {
    baseTokenURI = baseTokenURI_;
  }

  /// @dev Sets the base token URI prefix.
  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  /** PAYOUT **/

  function withdraw() public nonReentrant {
    uint256 balance = address(this).balance;

    Address.sendValue(payable(owner()), balance * 40 / 100);

    Address.sendValue(payable(galleryAddress), balance * 30 / 100);

    Address.sendValue(payable(artistAddress), balance * 30 / 100);
  }

  /** ROYALTIES **/

  function royaltyInfo(uint256, uint256 salePrice) external view override
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
    return (
      interfaceId == type(IERC2981).interfaceId ||
      super.supportsInterface(interfaceId)
    );
  }
}

// Forked from Studio 721
// https://721.so
