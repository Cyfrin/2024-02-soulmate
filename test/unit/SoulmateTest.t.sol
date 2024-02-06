// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {console2} from "forge-std/Test.sol";

import {BaseTest} from "./BaseTest.t.sol";
import {Soulmate} from "../../src/Soulmate.sol";

contract SoulmateTest is BaseTest {
    function test_MintNewToken() public {
        uint tokenIdMinted = 0;

        vm.prank(soulmate1);
        soulmateContract.mintSoulmateToken();

        assertTrue(soulmateContract.totalSupply() == 0);

        vm.prank(soulmate2);
        soulmateContract.mintSoulmateToken();

        assertTrue(soulmateContract.totalSupply() == 1);
        assertTrue(soulmateContract.soulmateOf(soulmate1) == soulmate2);
        assertTrue(soulmateContract.soulmateOf(soulmate2) == soulmate1);
        assertTrue(soulmateContract.ownerToId(soulmate1) == tokenIdMinted);
        assertTrue(soulmateContract.ownerToId(soulmate2) == tokenIdMinted);
    }

    function test_NoTransferPossible() public {
        _mintOneTokenForBothSoulmates();

        vm.prank(soulmate1);
        vm.expectRevert();
        soulmateContract.transferFrom(soulmate1, soulmate2, 0);
    }

    function compare(
        string memory str1,
        string memory str2
    ) public pure returns (bool) {
        return
            keccak256(abi.encodePacked(str1)) ==
            keccak256(abi.encodePacked(str2));
    }

    function test_WriteAndReadSharedSpace() public {
        vm.prank(soulmate1);
        soulmateContract.writeMessageInSharedSpace("Buy some eggs");

        vm.prank(soulmate2);
        string memory message = soulmateContract.readMessageInSharedSpace();

        string[4] memory possibleText = [
            "Buy some eggs, sweetheart",
            "Buy some eggs, darling",
            "Buy some eggs, my dear",
            "Buy some eggs, honey"
        ];
        bool found;
        for (uint i; i < possibleText.length; i++) {
            if (compare(possibleText[i], message)) {
                found = true;
                break;
            }
        }
        console2.log(message);
        assertTrue(found);
    }
}
