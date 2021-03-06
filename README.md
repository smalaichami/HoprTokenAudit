# Hopr Token And Distributor Smart Contract Audit

Status: **Work in progress**

<br />

## Summary

[Hopr](https://hoprnet.org/) intends to deploy an ERC-777 (and ERC-20) compliant token and a token distributor as smart contracts on the Ethereum blockchain.

Bok Consulting Pty Ltd has been commissioned to perform an audit on the Ethereum smart contracts.

This audit has been conducted on Hopr's source code as described in [AUDIT.md](https://github.com/hoprnet/hoprnet/blob/f38c4afd707b150f48095140fbaa6285d22efe5f/packages/ethereum/AUDIT.md). After an initial review (see recommendations below), the source code was updated in commit [663ed42](https://github.com/hoprnet/hoprnet/pull/969/commits/663ed4292cabe218923322133d3058d8cdae86a9) into [https://github.com/hoprnet/hoprnet/tree/release/titlis](https://github.com/hoprnet/hoprnet/tree/release/titlis). After the second review, the source code was updated in [PR #1265](https://github.com/hoprnet/hoprnet/pull/1265).

<br />

<hr />

## Table Of Contents

* [Summary](#summary)
* [Recommendations](#recommendations)

<br />

<hr />

## Recommendations


### Initial Review Recommendations
From the initial review of the source as described in [AUDIT.md](https://github.com/hoprnet/hoprnet/blob/f38c4afd707b150f48095140fbaa6285d22efe5f/packages/ethereum/AUDIT.md):

* [ ] [contracts/HoprDistributor.sol](contracts/HoprDistributor.sol) will not allow tokens to be claimed after Jan 19 2038 due to the use of `uint32` variables. Except for non-arrays and structs, it is generally cheaper gas-wise to use the native 256 bit `uint256` (or the `uint` alias) compared to `uint32` and `uint128`. Consider the gas cost operations over the life of the contract - write once, read many. Using `uint256` will also simplify the auditing of these contracts as there are less type conversions in the code.
  * [ ] **MEDIUM IMPORTANCE** Convert all `uint32` to `uint256`, e.g., [contracts/HoprDistributor.sol#L9](contracts/HoprDistributor.sol#L9)
  * [ ] **MEDIUM IMPORTANCE** Convert all `uint128` to `uint256`, e.g., [contracts/HoprDistributor.sol#L12](contracts/HoprDistributor.sol#L12)
  * [ ] **MEDIUM IMPORTANCE** Replace `_currentBlockTimestamp()` with `block.timestamp`, e.g., [contracts/HoprDistributor.sol#L194](contracts/HoprDistributor.sol#L194) and remove [`_currentBlockTimestamp()`](contracts/HoprDistributor.sol#L238-L241)
  * [ ] **MEDIUM IMPORTANCE** Remove `_addUint32(...)`, `_addUint128(...)`, `_subUint128(...)`, `_mulUint128(...)` and `_divUint128()` in [contracts/HoprDistributor.sol#L243-L281](contracts/HoprDistributor.sol#L243-L281) and use OpenZeppelin's SafeMath
* [x] **MEDIUM IMPORTANCE** Replace `lastDuration <= durations[i]` with `lastDuration < durations[i]` in [contracts/HoprDistributor.sol#L104](contracts/HoprDistributor.sol#L104) to prevent duplicate durations. Replaced in [663ed42](https://github.com/hoprnet/hoprnet/pull/969/commits/663ed4292cabe218923322133d3058d8cdae86a9)
* [x] **LOW IMPORTANCE** Check that the sum of `percents[]` adds up to `MULTIPLIER` in `addSchedule(...)` - [contracts/HoprDistributor.sol#L94-L112](contracts/HoprDistributor.sol#L94-L112), so exactly 100% of the tokens are claimable. Check added in [663ed42](https://github.com/hoprnet/hoprnet/pull/969/commits/663ed4292cabe218923322133d3058d8cdae86a9)
* [ ] **LOW IMPORTANCE** Refactor the statements in `_getClaimable(...)`[contracts/HoprDistributor.sol#L227-L230](contracts/HoprDistributor.sol#L227-L230) to remove the `break` and `continue` to simplify the algorithm
* [x] **LOW IMPORTANCE** Move the events from [contracts/HoprDistributor.sol#L283-L285](contracts/HoprDistributor.sol#L283-L285) before the constructor - see [style guide](https://docs.soliditylang.org/en/v0.8.0/style-guide.html#order-of-layout). Moved in [663ed42](https://github.com/hoprnet/hoprnet/pull/969/commits/663ed4292cabe218923322133d3058d8cdae86a9)
* [x] **LOW IMPORTANCE** Move the structs from [contracts/HoprDistributor.sol#L23-L37](contracts/HoprDistributor.sol#L23-L37) before the variables - see [style guide](https://docs.soliditylang.org/en/v0.8.0/style-guide.html#order-of-layout). Moved in [663ed42](https://github.com/hoprnet/hoprnet/pull/969/commits/663ed4292cabe218923322133d3058d8cdae86a9)

<br />

### Second Review Recommendations

### Second Review Notes

* `_msgSender()` should be used instead of `msg.sender` for consistency with AccessControl's Context with GSN in `HoprToken.constructor()` and `HoprToken.mint(...)`
* `_msgSender()` should be used instead of `msg.sender` for consistency with Ownable's Context with GSN in `HoprDistributor.claim(...)`
* Solidity `^0.6.0` specified. Using Solidity 0.6.12 for this review. Please check specific compiler version issues if deploying with a different version
* `tokenId` should be renamed `amount` in `ERC777._beforeTokenTransfer(...)` - This has been fixed in the current OpenZeppelin version of [ERC777.sol](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC777/ERC777.sol)

<br />

<hr />

### Source Code

Following are the contracts being audited:

* [contracts_original/HoprToken.sol](contracts_original/HoprToken.sol) - [source - initial review](https://github.com/hoprnet/hoprnet/blob/f38c4afd707b150f48095140fbaa6285d22efe5f/packages/ethereum/contracts/HoprToken.sol), [source - latest](https://github.com/hoprnet/hoprnet/blob/release/titlis/packages/ethereum/contracts/HoprToken.sol).
* [contracts_original/ERC777/ERC777Snapshot.sol](contracts_original/ERC777/ERC777Snapshot.sol) - [source - initial review](https://github.com/hoprnet/hoprnet/blob/f38c4afd707b150f48095140fbaa6285d22efe5f/packages/ethereum/contracts/ERC777/ERC777Snapshot.sol), [source - latest](https://github.com/hoprnet/hoprnet/blob/release/titlis/packages/ethereum/contracts/ERC777/ERC777Snapshot.sol).
* [contracts_original/HoprDistributor.sol](contracts_original/HoprDistributor.sol) - [source - initial review](https://github.com/hoprnet/hoprnet/blob/f38c4afd707b150f48095140fbaa6285d22efe5f/packages/ethereum/contracts/HoprDistributor.sol), [source - latest](https://github.com/hoprnet/hoprnet/blob/release/titlis/packages/ethereum/contracts/HoprDistributor.sol).

The original OpenZeppelin dependencies have also been added to [contracts_original/openzeppelin](contracts_original/openzeppelin).

Contracts from above, modified for testing:

* [contracts/HoprToken.sol](contracts/HoprToken.sol)
* [contracts/ERC777/ERC777Snapshot.sol](contracts/ERC777/ERC777Snapshot.sol)
* [contracts/HoprDistributor.sol](contracts/HoprDistributor.sol)
* [contracts/openzeppelin](contracts/openzeppelin)

<br />

### OpenZeppelin version

* `"@openzeppelin/contracts": "^3.0.1", ` https://github.com/hoprnet/hoprnet/blob/f38c4afd707b150f48095140fbaa6285d22efe5f/packages/ethereum/package.json#L30

  * https://github.com/OpenZeppelin/openzeppelin-contracts/releases/tag/v3.0.1
  * Minor non-code changes to v3.0.2 (release version of v3.0.1) - https://github.com/OpenZeppelin/openzeppelin-contracts/commit/5294f3b9b7f9b971db1ac53a127427621815cde4

<br />

<hr />

## Testing Environment

Hardhat https://hardhat.org/


npx hardhat

npm install --save-dev @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers

Using latest Solidity ^0.6.0 => 0.6.12 currently

<br />

<hr />

## Source Code

Flattened with OpenZeppelin v3.0.2.

### HoprToken

* [contracts/HoprToken.sol](contracts/HoprToken.sol)
  * [contracts/openzeppelin/access/AccessControl.sol](contracts/openzeppelin/access/AccessControl.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/access/AccessControl.sol)
    * [contracts/openzeppelin/utils/EnumerableSet.sol](contracts/openzeppelin/utils/EnumerableSet.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/utils/EnumerableSet.sol)
    * [contracts/openzeppelin/utils/Address.sol](contracts/openzeppelin/utils/Address.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/utils/Address.sol)
    * [contracts/openzeppelin/GSN/Context.sol](contracts/openzeppelin/GSN/Context.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/GSN/Context.sol)
  * import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
    * [contracts/openzeppelin/token/ERC777/ERC777.sol](contracts/openzeppelin/token/ERC777/ERC777.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/token/ERC777/ERC777.sol)
      * `import "../../GSN/Context.sol";` - see below
      * [contracts/openzeppelin/token/ERC777/IERC777.sol](contracts/openzeppelin/token/ERC777/IERC777.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/token/ERC777/IERC777.sol)
      * [contracts/openzeppelin/token/ERC777/IERC777Recipient.sol](contracts/openzeppelin/token/ERC777/IERC777Recipient.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/token/ERC777/IERC777Recipient.sol)
      * [contracts/openzeppelin/token/ERC777/IERC777Sender.sol](contracts/openzeppelin/token/ERC777/IERC777Sender.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/token/ERC777/IERC777Sender.sol)
      * [contracts/openzeppelin/token/ERC20/IERC20.sol](contracts/openzeppelin/token/ERC20/IERC20.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/token/ERC20/IERC20.sol)
      * [contracts/openzeppelin/math/SafeMath.sol](contracts/openzeppelin/math/SafeMath.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/math/SafeMath.sol)
      * `import "../../utils/Address.sol";` - see below
      * [contracts/openzeppelin/introspection/IERC1820Registry.sol](contracts/openzeppelin/introspection/IERC1820Registry.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/introspection/IERC1820Registry.sol)
  * [contracts/ERC777/ERC777Snapshot.sol](contracts/ERC777/ERC777Snapshot.sol)
    * `import "@openzeppelin/contracts/math/SafeMath.sol";` - see above
    * `import "@openzeppelin/contracts/token/ERC777/ERC777.sol";` - see above

<br />

### HoprDistributor

* [contracts/HoprDistributor.sol](contracts/HoprDistributor.sol)
  * [contracts/openzeppelin/access/Ownable.sol](contracts/openzeppelin/access/Ownable.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/access/Ownable.sol)
    * [contracts/openzeppelin/GSN/Context.sol](contracts/openzeppelin/GSN/Context.sol) - [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.2/contracts/GSN/Context.sol)
  * `import "./HoprToken.sol";` - see above

<br />

### Code Review

Using [truffle-flattener](https://github.com/nomiclabs/truffle-flattener) and the script [10_flattenSolidityFiles.sh](10_flattenSolidityFiles.sh) to generate the flattened file [flattened/HoprDistributor_flattened.sol](flattened/HoprDistributor_flattened.sol) . Note that this contains the HoprToken contract.

These have been copied into the following files for code review:

* [code-review/HoprDistributor_flattened.md](code-review/HoprDistributor_flattened.md)

Outline:

* [x] contract Context
* [x] contract Ownable is Context
* [ ] library EnumerableSet
* [x] library Address
* [ ] abstract contract AccessControl
  * [ ] using EnumerableSet for EnumerableSet.AddressSet;
  * [ ] using Address for address;
* [x] interface IERC777
* [x] interface IERC777Recipient
* [x] interface IERC777Sender
* [x] interface IERC20
* [x] library SafeMath
* [x] interface IERC1820Registry
* [ ] contract ERC777 is Context, IERC777, IERC20
  * [ ] using SafeMath for uint256;
  * [ ] using Address for address;
* [ ] abstract contract ERC777Snapshot is ERC777
  * [ ] using SafeMath for uint256;
* [ ] contract HoprToken is AccessControl, ERC777Snapshot
  * [ ] ERC20
    * [ ] function totalSupply()
    * [ ] function balanceOf(...)
    * [ ] function transfer(...)
    * [ ] function allowance(...)
    * [ ] function approve(...)
    * [ ] function transferFrom(...)
    * [ ] event Transfer
    * [ ] event Approval
  * [ ] ERC777
    * [ ] function name()
    * [ ] function symbol()
    * [ ] function decimals() - Note that this is not defined in IERC20 and IERC777
    * [ ] function granularity()
    * [ ] function totalSupply()
    * [ ] function balanceOf(...)
    * [ ] function send(...)
    * [ ] function burn(...)
    * [ ] function isOperatorFor(...)
    * [ ] function authorizeOperator(...)
    * [ ] function revokeOperator(...)
    * [ ] function defaultOperators() - Note that this is empty for these contracts
    * [ ] function operatorSend(...)
    * [ ] function operatorBurn(...)
    * [ ] event Sent
    * [ ] event Minted
    * [ ] event Burned
    * [ ] event AuthorizedOperator
    * [ ] event RevokedOperator
  * [ ] Snapshot
    * [ ] mapping(address, Snapshot[]) snapshots
    * [ ] Snapshot[] totalSupplySnapshots
    * [ ] function balanceOfAt(...) view
    * [ ] function totalSupplyAt(...) view
  * [ ] Other
    * [ ] bytes32 DEFAULT_ADMIN_ROLE
    * [ ] bytes32 MINTER_ROLE
    * [ ] constructor(...)
    * [ ] function hasRole(...) view
    * [ ] function getRoleMemberCount(...) view
    * [ ] function getRoleMember(...) view
    * [ ] function getRoleAdmin(...) view
    * [ ] function grantRole(...) adminRole
    * [ ] function revokeRole(...) adminRole
    * [ ] function renounceRole(...)
    * [ ] function mint(...) MINTER_ROLE
    * [ ] event RoleGranted
    * [ ] event RoleRevoked
* [ ] contract HoprDistributor is Ownable -  NOTE - The use of `assert(...)` in `HoprDistributor` will result in ALL gas being consumed if an error condition occurs. Use `revert(...)` or `require(...)` as any remaining gas will be refunded
  * [x] struct Schedule
  * [x] struct Allocation
  * [x] uint128 constant MULTIPLIER
  * [x] uint128 totalMinted
  * [x] uint128 totalToBeMinted - NOTE - See issues with `revokeAccount(...)`
  * [x] uint128 startTime - NOTE - See warnings on `updateStartTime(...)`
  * [x] HoprToken token
  * [x] uint128 maxMintAmount
  * [x] mapping(string => Schedule) schedules
  * [x] mapping(address => string => Allocation) allocations
  * [x] event Ownable.OwnershipTransferred
  * [x] event ScheduleAdded
  * [x] event AllocationAdded
  * [x] event Claimed
  * [x] constructor(...) -> Ownable.constructor(...)
  * [x] function Ownable.owner() view
  * [x] function Ownable.renounceOwnership() onlyOwner
  * [x] function Ownable.transferOwnership(...) onlyOwner
  * [x] function getSchedule(...) view
  * [x] function revokeAccount(...) onlyOwner - WARNING - The owner can execute `revokeAccount(...)` for the same account and schedule name multiple times. This will result in an incorrect `totalToBeMinted` indicator variable, and possibly the disabling of this `revokeAccount(...)` function if `totalToBeMinted` underflows. Consider adding a check to only allow the revocation of accounts that have not been already revoked
  * [x] function addSchedule(...) onlyOwner
  * [x] function addAllocations(...) onlyOwner - NOTE - `assert(_totalToBeMinted <= maxMintAmount);` in `HoprDistributor.addAllocations(...)` can be moved after the `for (...)` loop to save a bit more gas
  * [x] function claim(...)
  * [x] function claimFor(...)
  * [x] function getClaimable(...) view
  * [ ] function _claim(...) internal
  * [x] function _getClaimable(...) internal

<br />

<hr />

## Testing

Installed and ran the `FORCE_COLOR=0 yarn test` with results saved into [test_results.script](test_results.script).

https://github.com/OpenZeppelin/openzeppelin-test-helpers

npm install --save-dev @openzeppelin/test-helpers

npm install --save-dev @nomiclabs/hardhat-web3 web3

Run [20_testHoprToken.sh](20_testHoprToken.sh) to execute the script [test/TestHoprToken.js](test/TestHoprToken.js) to generate [results/TestHoprToken.txt](results/TestHoprToken.txt).

<br />

<hr />

## Notes

* [x] NOTE - `assert(_totalToBeMinted <= maxMintAmount);` in `HoprDistributor.addAllocations(...)` can be moved after the `for (...)` loop to save a bit more gas
  * [x] Developer acknowledged, no changes
* [x] WARNING - The owner can execute `HoprDistributor.updateStartTime(...)` as long as the current `startTime` is in the future. The new `startTime` has no boundary checks so be careful when executing this function
  * [x] Developer acknowledged, with risk accepted
* [x] NOTE - `HoprDistributor.updateStartTime(...)` should ideally emit an event
  * [x] Developer acknowledged, no changes
* [x] WARNING - The owner can execute `HoprDistributor.revokeAccount(...)` for the same account and schedule name multiple times. This will result in an incorrect `totalToBeMinted` indicator variable, and possibly the disabling of this `revokeAccount(...)` function if `totalToBeMinted` underflows. Consider adding a check to only allow the revocation of accounts that have not been already revoked. See [`revokeAccount(...)` underflow testing results](https://github.com/bokkypoobah/HoprTokenAudit/blob/8eefbb8bccfca153342f769b1420256342ded7d4/results/TestHoprToken.txt#L159-L180)
  * [x] Updated [HoprDistributor.sol](https://github.com/hoprnet/hoprnet/blob/29ddf2500c2c5bd15035a9e994e08da9be2c269f/packages/ethereum/contracts/HoprDistributor.sol)
* NOTE - `HoprDistributor.revokeAccount(...)` should ideally emit an event
* [x] NOTE - The use of `assert(...)` in `HoprDistributor` will result in ALL gas being consumed if an error condition occurs. Use `revert(...)` or `require(...)` as any remaining gas will be refunded. See [Solidity `assert` and `require`](https://docs.soliditylang.org/en/v0.6.12/control-structures.html#id4)
  * [x] Developer acknowledged, no changes
* [x] NOTE - Consider adding a check to `HoprDistributor._claim(...)` to only mint tokens if `claimable > 0` - this will reduce the gas cost if an account claims more than once per period
  * [x] Developer acknowledged, no changes
* `uint128` used in HoprDistributor. Range is for a 18 decimal place number up to `340282366920938463463` (`new BigNumber(2).pow(128).sub(1).shift(-18).toFixed(18)`
* `defaultOperators` can transfer any account's tokens - need to confirm that this is left as an empty array after deployment

ERC777 transfer/transferFrom/send/mint/burn/operatorSend/operatorBurn workflows

```javascript
send(recipient, amount, data) public
  _send(_msgSender, recipient, amount, data, "", true)

transfer(recipient, amount) public returns (bool)
  _callTokensToSend(_msgSender, _msgSender, recipient, amount, "", "")
  _move(_msgSender, _msgSender, recipient, amount, "", "")
  _callTokensReceived(_msgSender, _msgSender, recipient, amount, "", "", false)
  return true

burn(amount, data) public
  _burn(_msgSender, amount, data, "")

operatorSend(sender, recipient, amount, data, operatorData) public
  _send(sender, recipient, amount, data, operatorData, true)

operatorBurn(account, amount, data, operatorData) public
  _burn(account, amount, data, operatorData)

approve(spender, value) public returns (bool)
  _approve(_msgSender, spender, value);
  return true;

transferFrom(holder, recipient, amount) public returns (bool)
  _callTokensToSend(_msgSender, holder, recipient, amount, "", "")
  _move(spender, holder, recipient, amount, "", "")
  _approve(holder, spender, _allowances[holder][spender] - amount)
  _callTokensReceived(spender, holder, recipient, amount, "", "", false)
  return true

_mint(account, amount, userData, operatorData) internal virtual
  _beforeTokenTransfer(operator, address(0), account, amount)
  _totalSupply += amount
  _balances[account] += amount
  _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true)
  emit Minted(operator, account, amount, userData, operatorData);
  emit Transfer(address(0), account, amount);

_send(from, to, amount, userData, operatorData, requireReceptionAck) internal
  _callTokensToSend(_msgSender, from, to, amount, userData, operatorData)
  _move(_msgSender, from, to, amount, userData, operatorData)
  _callTokensReceived(_msgSender, from, to, amount, userData, operatorData, requireReceptionAck)

_burn(from, amount, data, operatorData) internal virtual
  _beforeTokenTransfer(_msgSender, from, address(0), amount)
  _callTokensToSend(_msgSender, from, address(0), amount, data, operatorData)
  _balances[from] -= amount
  _totalSupply -= amount
  emit Burned(operator, from, amount, data, operatorData);
  emit Transfer(from, address(0), amount);

_move(operator, from, to, amount, userData, operatorData) private
  _beforeTokenTransfer(operator, from, to, amount)
  _balances[from] -= amount
  _balances[to] += amount
  emit Sent(operator, from, to, amount, userData, operatorData);
  emit Transfer(from, to, amount);

_approve(holder, spender, value) internal
  _allowances[holder][spender] = value
  emit Approval(holder, spender, value)

_callTokensToSend(operator, from, to, amount, userData, operatorData) private
  implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
  if (implementer != address(0)) {
    IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
  }

_callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck) private
  implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
  if (implementer != address(0)) {
    IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
  } else if (requireReceptionAck) {
    require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
  }

_beforeTokenTransfer(operator, from, to, tokenId) internal virtual {}

ERC777Snapshot._beforeTokenTransfer(operator, from, to, amount) internal virtual override
  super._beforeTokenTransfer(operator, from, to, amount);
  if (from == address(0)) {
      // mint
      updateValueAtNow(accountSnapshots[to], balanceOf(to) + amount);
      updateValueAtNow(totalSupplySnapshots, totalSupply() + amount);
  } else if (to == address(0)) {
      // burn
      updateValueAtNow(accountSnapshots[from], balanceOf(from) - amount);
      updateValueAtNow(totalSupplySnapshots, totalSupply() - amount);
  } else if (from != to) {
      // transfer
      updateValueAtNow(accountSnapshots[from], balanceOf(from) - amount);
      updateValueAtNow(accountSnapshots[to], balanceOf(to) + amount);
  }
```
