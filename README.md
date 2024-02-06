# Soulmate

# Disclaimer

_This code was created for Codehawks as the first flights for Valentine's day. It is made with bugs and flaws on purpose._
_Don't use any part of this code without reviewing it and audit it._

# About

Valentine's day is approaching, and with that, it's time to meet your soulmate!

We've created the Soulmate protocol, where you can mint your shared Soulbound NFT with an unknown person, and get `LoveToken` as a reward for staying with your soulmate.
A staking contract is available to collect more love. Because if you give love, you receive more love.

## Soulmate.sol

The Soulbound NFT shared by soulmates used in the protocol.
It is used by Airdrop.sol and Staking.sol to know how long the couple are in love.

The main functions are:

- `mintSoulmateToken`: Where you'll mint a soulbound NFT. You'll either be assigned to someone else who is waiting for a soulmate, or you'll be waiting for a soulmate to be assigned to you.
- `soulmateOf`: Where you can see the soulmate of an address. If it returns `address(0)` then a soulmate has not been assigned yet.
- `writeMessageInSharedSpace`: Where you can write messages to your soulmate.

Everyone should be able to be minted a soulmate.

And finally, sometimes, love can be hard, even if it is your soulmate... but there is always another solution : get divorced.

- `getDivorced`: Where you and your soulmate are separated and no longer soulmates. This will cancel the possibily for 2 lovers to collect LoveToken from the airdrop. There is and should be no way to undo this action.

## LoveToken.sol

A basic ERC20 Token given to soulmates. The initial supply is distributed to 2 instances of `Vault.sol` managed by:

- `Airdrop.sol`
- `Staking.sol`

This token represents how much love there is between two soulmates.

## Airdrop.sol

Once you have a soulmate, you can claim 1 LoveToken a day.

This contract has 1 main function:

- `claim`: Allows only those with a soulmate to collect 1 LoveToken per day. Both soulmates can collect 1 per day (aka, 2 per day per couple).

## Staking.sol

As you claim your LoveToken, you can stake it to claim even more!

This contract is dedicated to the staking functionality.
It has the following functions:

- `deposit`: Deposit LoveToken to the staking contract
- `withdraw`: Withdraw LoveToken from the staking contract
- `claimRewards`: Claim LoveToken rewards from the staking contract.

For every 1 token deposited and 1 week left in the contract, 1 LoveToken is rewarded.

Examples:

- 1 token deposited for 1 week = 1 LoveToken reward
- 7 tokens deposited for 2 weeks = 14 LoveToken reward

## Vault.sol

The vault contract is responsible for holding the love tokens, and approving the Staking and Airdrop contracts to pull funds from the Vaults. There will be 2 vaults:

- A vault to hold funds for the airdrop contract
- A vault to hold funds for the staking contract

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

# Usage

## Testing

```
forge test
```

### Test Coverage

```
forge coverage
```

and for coverage based testing:

```
forge coverage --report debug
```

# Audit Scope Details

- Commit Hash:
- In Scope:
  (For this contest, just use the main branch)

```
Hash:
```

## Compatibilities

- Solc Version: `0.8.23 < 0.9.0`
- Chain(s) to deploy contract to:
  - Ethereum

# Roles

None

# Known Issues

- Eventually, the counter used to give ids will reach the `type(uint256).max` and no more will be able to be minted. This is known and can be ignored.
