// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./libraries.sol";

contract Art3mis is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    
   string public constant MAJOR_ARCANA_URI = "ipfs://bafybeihrnhjv4ceqvltg3mygifiukety4suhzbd7q2givhbepucvl2xn2e/";
    string[22] private MAJOR_ARCANA_NAME = [
        "0 The Fool",
        "I The Magician",
        "II The High Priestess",
        "III The Empress",
        "IV The Emperor",
        "V The Hierophant",
        "VI The Lovers",
        "VII The Chariot",
        "VIII Strength",
        "IX The Hermit",
        "X The Wheel of Fortune",
        "XI Justice",
        "XII The Hanged Man",
        "XIII Death",
        "XIV Temperance",
        "XV The Devil",
        "XVI The Tower",
        "XVII The Star",
        "XVIII The Moon",
        "XIX The Sun",
        "XX Judgement",
        "XXI The World"
    ];
    
    constructor() ERC721("Art3misTarot", "AT") {}
    
    /////////////////////////
    //   ENTRY FUNCTIONS   //
    ////////////////////////

    function drawCard() public view returns (string memory){
        uint256 card_index = random(22);
        string memory card = MAJOR_ARCANA_NAME[card_index];
        string memory position;
        if(random(2) == 0){
            position = "reverse";
        }else{
            position = "upright";
        }
        string memory card_uri = string(abi.encodePacked(MAJOR_ARCANA_URI, Strings.toString(card_index)));
        card_uri = string.concat(card_uri, ".png");
        string memory output = string.concat(card, "; ");
        output = string.concat(output, position);
        output = string.concat(output, "; ");
        output = string.concat(output, card_uri);
        return output;
    }
    
    function mintReading(address to, string memory tokenURI) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }
    
    ///////////////////////////////
    //   PUBLIC VIEW FUNCTIONS   //
    //////////////////////////////

    function getCurrentTokenId() public view returns (uint) {
        return _tokenIdCounter.current();
    }

    ///////////////////////////////
    //   HELPER FUNCTIONS   //
    //////////////////////////////

    // function random(uint256 upper_limit_exclude) private view returns (uint) {
    //     uint randomHash = uint(keccak256(abi.encodePacked(block.difficulty, now)));
    //     return randomHash % upper_limit_exclude;
    // } 

    function random(uint256 upper_limit_excluded) internal view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(
            tx.origin,
            blockhash(block.number - 1),
            block.timestamp
        )));
        return rand % upper_limit_excluded;
  }

    function indexOf(string[] memory arr, string memory searchFor) pure private returns (int) {
        for (uint i = 0; i < arr.length; i++) {
            if (keccak256(abi.encodePacked(arr[i])) == keccak256(abi.encodePacked(searchFor))) {
            return int(i);
            }
        }
        return -1; // not found
    }

}
