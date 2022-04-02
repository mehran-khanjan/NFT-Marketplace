// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFT.sol";

contract ArtMarketplace {
    NFT private token;

    struct ItemForSale {
        uint256 id;
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool isSold;
    }

    ItemForSale[] public itemsForSale;
    mapping(uint256 => bool) public activeItems; // tokenId => ativo?

    event itemAddedForSale(uint256 id, uint256 tokenId, uint256 price);
    event itemSold(uint256 id, address buyer, uint256 price);

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

    modifier ItemExists(uint256 id){
        require(id < itemsForSale.length && itemsForSale[id].id == id, "Could not find item");
        _;
    }

    modifier IsForSale(uint256 id){
        require(!itemsForSale[id].isSold, "Item is already sold");
        _;
    }

    function putItemForSale(uint256 tokenId, uint256 price)
    OnlyItemOwner(tokenId)
    HasTransferApproval(tokenId)
    external
    returns (uint256){
        require(!activeItems[tokenId], "Item is already up for sale");

        uint256 newItemId = itemsForSale.length;
        itemsForSale.push(ItemForSale({
        id: newItemId,
        tokenId: tokenId,
        seller: payable(msg.sender),
        price: price,
        isSold: false
        }));
        activeItems[tokenId] = true;

        assert(itemsForSale[newItemId].id == newItemId);
        emit itemAddedForSale(newItemId, tokenId, price);
        return newItemId;
    }

}