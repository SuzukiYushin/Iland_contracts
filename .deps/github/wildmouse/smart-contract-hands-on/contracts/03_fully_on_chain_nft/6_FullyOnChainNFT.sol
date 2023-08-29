// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FullyOnChainNFT is ERC721 {

    struct Colors {
        string color1;
        string color2;
        string color3;
        string color4;
    }

    mapping(uint256 => bytes32) public tokenParameters;

    constructor() ERC721("OnChainNFT", "OCN") {}

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

    function parseColors(string calldata hexString) external pure returns(Colors memory) {
        return Colors(hexString[3:9], hexString[9:15], hexString[15:21], hexString[21:27]);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "SVGOnChainNFT: URI query for nonexistent token");

        bytes32 tokenParameter = tokenParameters[tokenId];
        string memory parameterString = Strings.toHexString(uint256(tokenParameter));
        Colors memory colors = FullyOnChainNFT(address(this)).parseColors(parameterString);

        string memory svg = string(abi.encodePacked(
            '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">'
                '<rect x="0" y="0" width="200" height="200" fill="#', colors.color1, '" />'
                '<rect x="200" y="0" width="200" height="200" fill="#', colors.color2, '" />'
                '<rect x="0" y="200" width="200" height="200" fill="#', colors.color3, '" />'
                '<rect x="200" y="200" width="200" height="200" fill="#', colors.color4, '" />'
            '</svg>'
        ));

        return string(abi.encodePacked(
            '{'
                '"name": "Fully on chain token", '
                '"description": "This is fully on chain nft", '
                '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(svg)), '"'
            '}'
        ));
    }
}


/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}