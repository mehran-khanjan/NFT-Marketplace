// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFT.sol";

contract ArtMarketplace {
    NFT private token;

    constructor(NFT _token) {
        token = _token;
    }

    modifier OnlyItemOwner(uint256 tokenId){
        require(token.ownerOf(tokenId) == msg.sender, "Sender does not own the item");
        _;
    }

    modifier HasTransferApproval(uint256 tokenId){
        require(token.getApproved(tokenId) == address(this), "Market is not approved");
        _;
    }

}