// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

interface ISoulmate {
    function idToCreationTimestamp(uint256 id) external returns (uint256);

    function soulmateOf(address soulmate) external returns (address);

    function sharedSpace(uint256 id) external returns (string memory);

    function ownerToId(address owner) external returns (uint256);

    function mintSoulmateToken() external returns (uint256);

    function tokenURI(uint256) external pure returns (string memory);

    function transferFrom(address from, address to, uint256 id) external;

    function writeMessageInSharedSpace(string calldata message) external;

    function readMessageInSharedSpace()
        external
        view
        returns (string memory message);

    function getDivorced() external;

    function isDivorced() external view returns (bool);

    function totalSupply() external view returns (uint256);

    function totalSouls() external view returns (uint256);
}
