// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFT.sol";

contract ArtMarketplace {
    NFT private token;

    constructor(NFT _token) {
        token = _token;
    }
}