// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";

import {IVault} from "../../src/interface/IVault.sol";
import {ISoulmate} from "../../src/interface/ISoulmate.sol";
import {ILoveToken} from "../../src/interface/ILoveToken.sol";
import {IStaking} from "../../src/interface/IStaking.sol";

import {Vault} from "../../src/Vault.sol";
import {Soulmate} from "../../src/Soulmate.sol";
import {LoveToken} from "../../src/LoveToken.sol";
import {Airdrop} from "../../src/Airdrop.sol";
import {Staking} from "../../src/Staking.sol";

contract BaseTest is Test {
    Soulmate public soulmateContract;
    LoveToken public loveToken;
    Staking public stakingContract;
    Airdrop public airdropContract;
    Vault public airdropVault;
    Vault public stakingVault;

    address deployer = makeAddr("deployer");
    address soulmate1 = makeAddr("soulmate1");
    address soulmate2 = makeAddr("soulmate2");

    function setUp() public {
        vm.startPrank(deployer);
        airdropVault = new Vault();
        stakingVault = new Vault();
        soulmateContract = new Soulmate();
        loveToken = new LoveToken(
            ISoulmate(address(soulmateContract)),
            address(airdropVault),
            address(stakingVault)
        );
        stakingContract = new Staking(
            ILoveToken(address(loveToken)),
            ISoulmate(address(soulmateContract)),
            IVault(address(stakingVault))
        );

        airdropContract = new Airdrop(
            ILoveToken(address(loveToken)),
            ISoulmate(address(soulmateContract)),
            IVault(address(airdropVault))
        );
        airdropVault.initVault(
            ILoveToken(address(loveToken)),
            address(airdropContract)
        );
        stakingVault.initVault(
            ILoveToken(address(loveToken)),
            address(stakingContract)
        );

        // init
        vm.stopPrank();
    }

    function _mintOneTokenForBothSoulmates() internal {
        vm.prank(soulmate1);
        soulmateContract.mintSoulmateToken();

        vm.prank(soulmate2);
        soulmateContract.mintSoulmateToken();
    }

    function _giveLoveTokenToSoulmates(uint amount) internal {
        _mintOneTokenForBothSoulmates();
        uint numberDays = amount / 1e18;
        vm.warp(block.timestamp + (numberDays * 1 days));

        vm.prank(soulmate1);
        airdropContract.claim();

        vm.prank(soulmate2);
        airdropContract.claim();
    }

    function _depositTokenToStake(uint amount) internal {
        _giveLoveTokenToSoulmates(amount);
        vm.startPrank(soulmate1);
        loveToken.approve(address(stakingContract), amount);
        stakingContract.deposit(amount);
        vm.stopPrank();

        vm.startPrank(soulmate2);
        loveToken.approve(address(stakingContract), amount);
        stakingContract.deposit(amount);
        vm.stopPrank();
    }
}
