// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract RFT {
    address public owner;
    mapping(address => bool) public bidders;
    uint public bidEndTime;
    address public highestBidder;
    uint public highestBid;

    constructor() {
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

    function award() public {
        require(msg.sender == owner, "Only the RFT owner can award the contract.");
        require(block.timestamp > bidEndTime, "Bidding period is not yet over.");

        // transfer NFT to the highest bidder
    }
}