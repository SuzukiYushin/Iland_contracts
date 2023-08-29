// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ilandstest is ERC721 {
    address owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() {
    owner = msg.sender;
    }

    using Strings for uint256;

    mapping(uint256 => bytes32) public tokenParameters;

    constructor() ERC721("ilands", "OCP") {}

    function mintNFT() public {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        // tokenParameters[tokenId] = cid;
        _mint(msg.sender, tokenId);
    }

    // function generateParameter(uint256 tokenId) internal returns(bytes32) {
    //     bytes32 tokenParameter =
    //     keccak256(abi.encodePacked(tokenId, block.timestamp, msg.sender));
    //     return tokenParameter;
    // }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ilands: URI query for nonexistent token");

        bytes32 tokenParameter = tokenParameters[tokenId];
        return string(abi.encodePacked(
            '{'
                '"name": "ilands token", '
                '"description": "This is ilands nft", '
                '"image": "https://copper-shy-parrotfish-397.mypinata.cloud/ipfs/',
                uint256(tokenParameter).toHexString(),
                '"'
            '}'
            )
        );
    }
}