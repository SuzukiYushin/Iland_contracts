// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Iland is ERC721 {
    uint[] responsebuf = [10, 5 ]; //for debug

    address owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    using Strings for uint256;

    mapping(uint256 => string) public tokenParameters;
    mapping(uint256 => address) public artistsAddress;
    mapping(uint256 => address[100]) public curatorsAddress;

    uint public curatorsAddressSize = 0;

    constructor(address multiSigWallet) ERC721("OnChainParamNFT", "OCP") {
        owner = multiSigWallet;
    }

    //1.Register Artwork by artists
    function registerArtwork(string calldata cid) public returns(uint256) {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        tokenParameters[tokenId] = cid;
        artistsAddress[tokenId] = msg.sender;

        return tokenId;
    }

    //2.Introduce NFT by curators
    function introduceNFT(uint256 tokenId) public {
        curatorsAddress[tokenId][curatorsAddressSize] = msg.sender;
        curatorsAddressSize++;
    }

    //3.Buy NFT and mint by consumers
    function buyNFT(uint256 tokenId) public payable {
        require(0.01 ether == msg.value);

        address introducedAddress;
        uint256 amount;

        for (uint i = 0; i < curatorsAddressSize; i++){
            introducedAddress = curatorsAddress[tokenId][i];
            //call some web2 API using "introducedAddress"
            //responce ex
            /*
                '{'
                    '"like": 10, '
                    '"reIntroduce": 5, '
                '}'
            */

            uint like = responsebuf[0]; //assin like value
            uint reIntroduce = responsebuf[1]; //assin reIntroduce value

            amount = msg.value * (like + reIntroduce) / 100;
            Address.sendValue(payable (curatorsAddress[tokenId][i]) , amount);
        }

        amount = msg.value * 30 / 100;
        Address.sendValue(payable (artistsAddress[tokenId]) , amount);

        _mint(msg.sender, tokenId);
    }

    //4.Respon metadata for market place
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ilands: URI query for nonexistent token");

        string memory tokenParameter = tokenParameters[tokenId];
        return string(abi.encodePacked(
            '{'
                '"name": "ilands token", '
                '"description": "This is ilands nft", '
                '"image": "https://copper-shy-parrotfish-397.mypinata.cloud/ipfs/',
                tokenParameter, 
                '"'
            '}'
            )
        );
    }
    
}