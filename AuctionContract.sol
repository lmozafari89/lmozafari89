// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address public highestBidder;
    uint256 public highestBid;

    function bid() public payable {
        require(msg.value > highestBid, "Bid too low");
        if (highestBidder != address(0)) {
            payable(highestBidder).transfer(highestBid);
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdraw() public {
        require(msg.sender != highestBidder, "Highest bidder cannot withdraw");
        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }
}
