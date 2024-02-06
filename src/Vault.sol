// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {ILoveToken} from "./interface/ILoveToken.sol";

/// @title Vault Contract.
/// @author n0kto
/// @notice 2 vaults will be created : one for airdrop and one for staking.
contract Vault {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error Vault__AlreadyInitialized();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    bool public vaultInitialize;

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Init vault with the loveToken.
    /// @notice Vault will approve its corresponding management contract to handle tokens.
    /// @notice vaultInitialize protect against multiple initialization.
    function initVault(ILoveToken loveToken, address managerContract) public {
        if (vaultInitialize) revert Vault__AlreadyInitialized();
        loveToken.initVault(managerContract);
        vaultInitialize = true;
    }
}
