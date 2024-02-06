// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {ERC721} from "@solmate/tokens/ERC721.sol";

/// @title Soulmate Soulbound NFT.
/// @author n0kto
/// @notice A Soulbound NFT sharing by soulmates.
contract Soulmate is ERC721 {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    error Soulmate__alreadyHaveASoulmate(address soulmate);
    error Soulmate__SoulboundTokenCannotBeTransfered();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    string[4] niceWords = ["sweetheart", "darling", "my dear", "honey"];

    mapping(uint256 id => address[2] owners) private idToOwners;
    mapping(uint256 id => uint256 timestamp) public idToCreationTimestamp;
    mapping(address soulmate1 => address soulmate2) public soulmateOf;
    mapping(address owner => uint256 id) public ownerToId;

    mapping(address owner => bool isDivorced) private divorced;

    mapping(uint256 id => string) public sharedSpace;

    uint256 private nextID;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event MessageWrittenInSharedSpace(uint256 indexed id, string message);

    event SoulmateIsWaiting(address indexed soulmate);

    event SoulmateAreReunited(
        address indexed soulmate1,
        address indexed soulmate2,
        uint256 indexed tokenId
    );

    event CoupleHasDivorced(
        address indexed soulmate1,
        address indexed soulmate2
    );

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor() ERC721("Soulmate", "SLMT") {}

    /// @notice Used to mint a token when soulmates are reunited.
    /// @notice Soulmates are reunited every time a second people try to mint the same ID.
    /// @return ID of the minted NFT.
    function mintSoulmateToken() public returns (uint256) {
        // Check if people already have a soulmate, which means already have a token
        address soulmate = soulmateOf[msg.sender];
        if (soulmate != address(0))
            revert Soulmate__alreadyHaveASoulmate(soulmate);

        address soulmate1 = idToOwners[nextID][0];
        address soulmate2 = idToOwners[nextID][1];
        if (soulmate1 == address(0)) {
            idToOwners[nextID][0] = msg.sender;
            ownerToId[msg.sender] = nextID;
            emit SoulmateIsWaiting(msg.sender);
        } else if (soulmate2 == address(0)) {
            idToOwners[nextID][1] = msg.sender;
            // Once 2 soulmates are reunited, the token is minted
            ownerToId[msg.sender] = nextID;
            soulmateOf[msg.sender] = soulmate1;
            soulmateOf[soulmate1] = msg.sender;
            idToCreationTimestamp[nextID] = block.timestamp;

            emit SoulmateAreReunited(soulmate1, soulmate2, nextID);

            _mint(msg.sender, nextID++);
        }

        return ownerToId[msg.sender];
    }

    /// @dev will be added after audit.
    /// @dev Since it is only used by wallets, it won't create any edge case.
    function tokenURI(uint256) public pure override returns (string memory) {
        // To do
        return "";
    }

    /// @notice Override of transferFrom to prevent any transfer.
    function transferFrom(address, address, uint256) public pure override {
        // Soulbound token cannot be transfered
        // Having a soulmate is for life !
        revert Soulmate__SoulboundTokenCannotBeTransfered();
    }

    /// @notice Allows any soulmates with the same NFT ID to write in a shared space on blockchain.
    /// @param message The message to write in the shared space.
    function writeMessageInSharedSpace(string calldata message) external {
        uint256 id = ownerToId[msg.sender];
        sharedSpace[id] = message;
        emit MessageWrittenInSharedSpace(id, message);
    }

    /// @notice Allows any soulmates with the same NFT ID to read in a shared space on blockchain.
    function readMessageInSharedSpace() external view returns (string memory) {
        // Add a little touch of romantism
        return
            string.concat(
                sharedSpace[ownerToId[msg.sender]],
                ", ",
                niceWords[block.timestamp % niceWords.length]
            );
    }

    /// @notice Cancel possibily for 2 lovers to collect LoveToken from the airdrop.
    function getDivorced() public {
        address soulmate2 = soulmateOf[msg.sender];
        divorced[msg.sender] = true;
        divorced[soulmateOf[msg.sender]] = true;
        emit CoupleHasDivorced(msg.sender, soulmate2);
    }

    function isDivorced() public view returns (bool) {
        return divorced[msg.sender];
    }

    function totalSupply() external view returns (uint256) {
        return nextID;
    }

    function totalSouls() external view returns (uint256) {
        return nextID * 2;
    }
}
