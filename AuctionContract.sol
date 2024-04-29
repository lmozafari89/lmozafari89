// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address public highestBidder;
    uint256 public highestBid;
    bool public ended;

    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 highestBid);

    function bid() public payable {
        require(!ended, "Auction already ended");
        require(msg.value > highestBid, "Bid must be higher than the current highest bid");

        if (highestBidder != address(0)) {
            payable(highestBidder).transfer(highestBid);
        }
        
        highestBidder = msg.sender;
        highestBid = msg.value;

        emit BidPlaced(msg.sender, msg.value);
    }

    function withdraw() public {
        require(msg.sender != highestBidder, "Highest bidder cannot withdraw");
        require(ended, "Auction not yet ended");

        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }

    function auctionEnd() public {
        require(!ended, "Auction already ended");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
    }
}
