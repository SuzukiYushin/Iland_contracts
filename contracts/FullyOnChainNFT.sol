// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FullyOnChainNFT is ERC721 {
    mapping(uint256 => bytes32) public tokenParameters;

    constructor() ERC721("FullyOnChainNFT","OCN") {}
    
    function mintNFT(uint256 tokenId) public {
    bytes32 tokenParameter = generateParameter(tokenId);
        tokenParameters[tokenId] = tokenParameter;
        _mint(msg.sender, tokenId);
    }

    function generateParameter(uint256 tokenId) internal view returns(bytes32) {
        bytes32 tokenParameter =
        keccak256(abi.encodePacked(tokenId, block.timestamp, msg.sender));
        return tokenParameter;
    }

    // function tokenURI(uint256 tokenId) public view override returns (string memory) {
    //     require(_exists(tokenId),
    //     "SVGOnChainNFT: URI query for nonexistent token");
    //     return string(abi.encodePacked(
    //     '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">'
    //     '<rect x="0" y="0" width="200" height="200" fill="#000000" />'
    //     '<rect x="200" y="0" width="200" height="200" fill="#cc0000" />'
    //     '<rect x="0" y="200" width="200" height="200" fill="#00cc00" />'
    //     '<rect x="200" y="200" width="200" height="200" fill="#0000cc" />'
    //     '</svg>'
    //     ));
    // }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId),
        "SVGOnChainNFT: URI query for nonexistent token");
        bytes32 tokenParameter = tokenParameters[tokenId];
        string memory parameterString = Strings.toHexString(uint256(tokenParameter));
        Colors memory colors = FullyOnChainNFT(address(this)).parseColors(parameterString);
        return string(abi.encodePacked(
        '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">'
        '<rect x="0" y="0" width="200" height="200" fill="#', colors.color1, '" />'
        '<rect x="200" y="0" width="200" height="200" fill="#', colors.color2, '" />'
        '<rect x="0" y="200" width="200" height="200" fill="#' , colors.color3, '" />'
        '<rect x="200" y="200" width="200" height="200" fill="#' , colors.color4, '" />'
        '</svg>'
        ));
    }

    struct Colors{
        string color1;
        string color2;
        string color3;
        string color4;
    }

    function parseColors(string calldata hexString)external pure returns(Colors memory){
        return Colors(
                hexString[3:9],
                hexString[9:15],
                hexString[15:21],
                hexString[21:27]
            );        
    }

}