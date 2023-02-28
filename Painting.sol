//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ArtToken is ERC721 {
    uint public artCount;
    mapping(uint => Art) public arts;
    
    struct Art {
        uint artId;
        address owner;
        string name;
        string description;
        uint price;
        bool sold;
    }
    
    constructor() ERC721("Art Token", "ART") {}
    
    function mint(address _to, uint _artId) internal {
        _safeMint(_to, _artId);
    }
    
    function createArt(string memory _name, string memory _description, uint _price) public {
        artCount++;
        arts[artCount] = Art(artCount, msg.sender, _name, _description, _price, false);
    }
    
    function buyArt(uint _artId) public payable {
        Art storage art = arts[_artId];
        require(!art.sold, "Artwork has already been sold");
        require(msg.value == art.price, "Incorrect payment amount");
        art.sold = true;
        art.owner = msg.sender;
        mint(msg.sender, _artId);
    }
    
    function getArt(uint _artId) public view returns (address, string memory, string memory, uint, bool) {
        Art storage art = arts[_artId];
        return (art.owner, art.name, art.description, art.price, art.sold);
    }
    
    function getArtIds() public view returns (uint[] memory) {
        uint[] memory artIds = new uint[](artCount);
        for (uint i = 1; i <= artCount; i++) {
            artIds[i - 1] = i;
        }
        return artIds;
    }
}
