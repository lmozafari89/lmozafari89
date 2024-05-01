// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address public owner;
    address public highestBidder;
    uint256 public highestBid;
    bool public ended;

    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 highestBid);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyBeforeEnd() {
        require(!ended, "Auction already ended");
        _;
    }

    modifier onlyAfterEnd() {
        require(ended, "Auction not yet ended");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function bid() public payable onlyBeforeEnd {
        require(msg.value > highestBid, "Bid must be higher than the current highest bid");

        if (highestBidder != address(0)) {
            payable(highestBidder).transfer(highestBid);
        }
        
        highestBidder = msg.sender;
        highestBid = msg.value;

        emit BidPlaced(msg.sender, msg.value);
    }

    function withdraw() public onlyAfterEnd {
        require(msg.sender != highestBidder, "Highest bidder cannot withdraw");

        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }

    function auctionEnd() public onlyOwner onlyBeforeEnd {
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
    }
}
