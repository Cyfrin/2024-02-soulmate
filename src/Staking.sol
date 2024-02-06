// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {IVault} from "./interface/IVault.sol";
import {ISoulmate} from "./interface/ISoulmate.sol";
import {ILoveToken} from "./interface/ILoveToken.sol";

/// @title Staking Contract for LoveToken.
/// @author n0kto
contract Staking {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error Staking__NoMoreRewards();
    error Staking__StakingPeriodTooShort();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    ILoveToken public immutable loveToken;
    ISoulmate public immutable soulmateContract;
    IVault public immutable stakingVault;

    mapping(address user => uint256 loveToken) public userStakes;
    mapping(address user => uint256 timestamp) public lastClaim;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event Deposited(address indexed user, uint256 amount);
    event Withdrew(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor(
        ILoveToken _loveToken,
        ISoulmate _soulmateContract,
        IVault _stakingVault
    ) {
        loveToken = _loveToken;
        soulmateContract = _soulmateContract;
        stakingVault = _stakingVault;
    }

    /// @notice Increase the userStakes variable and transfer LoveToken to this contract.
    function deposit(uint256 amount) public {
        if (loveToken.balanceOf(address(stakingVault)) == 0)
            revert Staking__NoMoreRewards();
        // No require needed because of overflow protection
        userStakes[msg.sender] += amount;
        loveToken.transferFrom(msg.sender, address(this), amount);

        emit Deposited(msg.sender, amount);
    }

    /// @notice Decrease the userStakes variable and transfer LoveToken to the user withdrawing.
    function withdraw(uint256 amount) public {
        // No require needed because of overflow protection
        userStakes[msg.sender] -= amount;
        loveToken.transfer(msg.sender, amount);
        emit Withdrew(msg.sender, amount);
    }

    /// @notice Claim rewards for staking.
    /// @notice Users can claim 1 token per staking token per week.
    function claimRewards() public {
        uint256 soulmateId = soulmateContract.ownerToId(msg.sender);
        // first claim
        if (lastClaim[msg.sender] == 0) {
            lastClaim[msg.sender] = soulmateContract.idToCreationTimestamp(
                soulmateId
            );
        }

        // How many weeks passed since the last claim.
        // Thanks to round-down division, it will be the lower amount possible until a week has completly pass.
        uint256 timeInWeeksSinceLastClaim = ((block.timestamp -
            lastClaim[msg.sender]) / 1 weeks);

        if (timeInWeeksSinceLastClaim < 1)
            revert Staking__StakingPeriodTooShort();

        lastClaim[msg.sender] = block.timestamp;

        // Send the same amount of LoveToken as the week waited times the number of token staked
        uint256 amountToClaim = userStakes[msg.sender] *
            timeInWeeksSinceLastClaim;
        loveToken.transferFrom(
            address(stakingVault),
            msg.sender,
            amountToClaim
        );

        emit RewardsClaimed(msg.sender, amountToClaim);
    }
}
