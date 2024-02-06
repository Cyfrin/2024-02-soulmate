// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {ILoveToken} from "./ILoveToken.sol";
import {ISoulmate} from "./ISoulmate.sol";

interface IStaking {
    function loveToken() external returns (ILoveToken);

    function soulmateContract() external returns (ISoulmate);

    function userStakes(address user) external returns (uint256);

    function lastClaim(address user) external returns (uint256);

    function deposit(uint256 amount) external;

    function withdraw(uint256 amount) external;

    function claimRewards() external;
}
