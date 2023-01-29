// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

contract RFT is IERC721, ERC721URIStorage{
    address public owner;
    mapping(address => bool) public bidders;
    uint public bidEndTime;
    address public highestBidder;
    uint public highestBid;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("TenderNFT", "RFT") {
        owner = msg.sender;
        bidEndTime = block.timestamp + 1 weeks;
    }

    function bid(uint _bid) public {
        require(msg.sender != owner, "Cannot bid on your own RFT.");
        require(block.timestamp <= bidEndTime, "Bidding period has ended.");
        require(_bid > highestBid, "Bid must be higher than current highest bid.");
        require(!bidders[msg.sender], "You have already placed a bid.");

        bidders[msg.sender] = true;
        highestBidder = msg.sender;
        highestBid = _bid;
    }

    function award(address serviceProvider, string memory tokenURI) public returns(uint256) {
        require(msg.sender == owner, "Only the RFT owner can award the contract.");
        require(block.timestamp > bidEndTime, "Bidding period is not yet over.");

        // transfer NFT to the highest bidder
        uint256 newItemId = _tokenIds.current();
        _mint(serviceProvider, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
}