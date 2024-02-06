// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {ILoveToken} from "./ILoveToken.sol";

interface IVault {
    function vaultInitialize() external view returns (bool);

    function initVault(ILoveToken loveToken, address manager) external;
}
