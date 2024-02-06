// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {ERC20} from "@solmate/tokens/ERC20.sol";

import {ISoulmate} from "./interface/ISoulmate.sol";

/// @title LoveToken ERC20.
/// @author n0kto
/// @notice An ERC20 Token who are airdrop to Soulmate NFT holders.
contract LoveToken is ERC20 {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error LoveToken__Unauthorized();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    ISoulmate public immutable soulmateContract;
    address public immutable airdropVault;
    address public immutable stakingVault;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event AirdropInitialized(address indexed airdropContract);
    event StakingInitialized(address indexed stakingContract);

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor(
        ISoulmate _soulmateContract,
        address _airdropVault,
        address _stakingVault
    ) ERC20("LoveToken", "<3", 18) {
        soulmateContract = _soulmateContract;
        airdropVault = _airdropVault;
        stakingVault = _stakingVault;
    }

    /// @notice Called at the launch of the protocol.
    /// @notice Will distribute all the supply to Airdrop and Staking Contract.
    function initVault(address managerContract) public {
        if (msg.sender == airdropVault) {
            _mint(airdropVault, 500_000_000 ether);
            approve(managerContract, 500_000_000 ether);
            emit AirdropInitialized(managerContract);
        } else if (msg.sender == stakingVault) {
            _mint(stakingVault, 500_000_000 ether);
            approve(managerContract, 500_000_000 ether);
            emit StakingInitialized(managerContract);
        } else revert LoveToken__Unauthorized();
    }
}
