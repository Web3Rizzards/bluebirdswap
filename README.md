# BluebirdSwap Fractionalised NFT Decentralised Options Trading - Solidity API Docs

## Deployments

| Name            | Description                                                                                           | Addresses                               |
| --------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------- |
| BluebirdManager | Manage the creation of option smart contracts                                                         | 0x...                       |
| BluebirdGrinder | Fractionalize NFT and Reconstruct NFT from fragments                                                  | 0x...                     |
| BluebirdOptions | Contract that holds the logic for peer-to-pool automated options writing for a single NFT collection. | 0x... |

## BB20

_Only can be issued by the BluebirdGrinder_

### grinder

```solidity
address grinder
```

Address of the BluebirdGrinder contract

### onlyGrinder

```solidity
modifier onlyGrinder()
```

Modifier to check if is called by the BluebirdGrinder

### constructor

```solidity
constructor(string _name, string _symbol, address _grinder) public
```

Constructor of the BB20 contract

#### Parameters

| Name      | Type    | Description                             |
| --------- | ------- | --------------------------------------- |
| \_name    | string  | Name of the token                       |
| \_symbol  | string  | Symbol of the token                     |
| \_grinder | address | Address of the BluebirdGrinder contract |

### mint

```solidity
function mint(address _receipient, uint256 _amount) external
```

Mint BB20 Tokens

_Only can be called by the BluebirdGrinder_

#### Parameters

| Name         | Type    | Description               |
| ------------ | ------- | ------------------------- |
| \_receipient | address | Address of the receipient |
| \_amount     | uint256 | Amount of tokens to mint  |

### burn

```solidity
function burn(uint256 amount) external returns (bool)
```

Burn `amount` tokens and decreasing the total supply.

_Only can be called by the BluebirdGrinder_

#### Parameters

| Name   | Type    | Description              |
| ------ | ------- | ------------------------ |
| amount | uint256 | Amount of tokens to burn |

### \_isFactory

```solidity
function _isFactory() internal view
```

Used in modifier to check if is called by the BluebirdGrinder

## BluebirdGrinder

### FRACTIONALISED_AMOUNT

```solidity
uint256 FRACTIONALISED_AMOUNT
```

Amount of BB20 tokens to mint per NFT

_1 NFT = 1 million BB20 tokens_

### collectionToTokenIds

```solidity
mapping(address => struct EnumerableSet.UintSet) collectionToTokenIds
```

Mapping of collection address to enumerable token Ids

### nftAddressToTokenAddress

```solidity
mapping(address => contract BB20) nftAddressToTokenAddress
```

Mapping of NFT collection address to BB20 token address

### whitelisted

```solidity
mapping(address => bool) whitelisted
```

Mapping of collection address to boolean to check if collection is whitelisted

### constructor

```solidity
constructor() public
```

### fractionalizeNFT

```solidity
function fractionalizeNFT(address _collectionAddress, uint256 _tokenId) external
```

Function to fractionalize NFTs into BB20 tokens

#### Parameters

| Name                | Type    | Description                      |
| ------------------- | ------- | -------------------------------- |
| \_collectionAddress | address | Address of NFT collection        |
| \_tokenId           | uint256 | Token Id of NFT to fractionalize |

### reconstructNFT

```solidity
function reconstructNFT(address _collectionAddress, uint256 _tokenId) external
```

Function to reconstruct NFTs from BB20 tokens

#### Parameters

| Name                | Type    | Description                    |
| ------------------- | ------- | ------------------------------ |
| \_collectionAddress | address | Address of NFT collection      |
| \_tokenId           | uint256 | Token Id of NFT to reconstruct |

### whitelistNFT

```solidity
function whitelistNFT(address _collectionAddress) external
```

Function to whitelist NFT collection

#### Parameters

| Name                | Type    | Description               |
| ------------------- | ------- | ------------------------- |
| \_collectionAddress | address | Address of NFT collection |

### getTokenFromCollection

```solidity
function getTokenFromCollection(address _collectionAddress) external view returns (contract IBB20)
```

Function to get token address from collection address

#### Parameters

| Name                | Type    | Description               |
| ------------------- | ------- | ------------------------- |
| \_collectionAddress | address | Address of NFT collection |

### getIds

```solidity
function getIds(address _collectionAddress) external view returns (uint256[])
```

Function to get all token ids from collection address that are in the contract

#### Parameters

| Name                | Type    | Description               |
| ------------------- | ------- | ------------------------- |
| \_collectionAddress | address | Address of NFT collection |

### concatenate

```solidity
function concatenate(string _a, string _b) internal pure returns (string)
```

Returns a concatenated string of a and b

#### Parameters

| Name | Type   | Description |
| ---- | ------ | ----------- |
| \_a  | string | string a    |
| \_b  | string | string b    |

## BluebirdManager

### optArray

```solidity
struct EnumerableSet.AddressSet optArray
```

Array of all options contract addresses

### optionPricing

```solidity
contract IOptionPricing optionPricing
```

Option Pricing Contract

### grinder

```solidity
contract IBluebirdGrinder grinder
```

Bluebird Grinder Contract

### optionExists

```solidity
mapping(address => bool) optionExists
```

Mapping of NFT token address to boolean to check if options have been created

### constructor

```solidity
constructor(contract IOptionPricing _optionPricing, contract IBluebirdGrinder _grinder) public
```

Constructor for Bluebird Manager

#### Parameters

| Name            | Type                      | Description               |
| --------------- | ------------------------- | ------------------------- |
| \_optionPricing | contract IOptionPricing   | Option Pricing Contract   |
| \_grinder       | contract IBluebirdGrinder | Bluebird Grinder Contract |

### onlyOptions

```solidity
modifier onlyOptions()
```

Modifier to check if msg.sender is an Options Contract

### createOptions

```solidity
function createOptions(address _collectionAddress, address _nftFeedAddress) public
```

Create a Put and Call Options for a specified collection for the current epoch

#### Parameters

| Name                | Type    | Description            |
| ------------------- | ------- | ---------------------- |
| \_collectionAddress | address | Collection Address     |
| \_nftFeedAddress    | address | Chainlink Feed Address |

### getOptArray

```solidity
function getOptArray() external view returns (address[])
```

Function to retrieve options array

### emitCallOptionCreatedEvent

```solidity
function emitCallOptionCreatedEvent(address _contractAddress, uint256 _optionId, uint256 _epoch, address _nftToken, uint256 _strikePrice, uint256 _start, uint256 _expiry) external
```

Proxy function to emit event from options contract

#### Parameters

| Name              | Type    | Description                 |
| ----------------- | ------- | --------------------------- |
| \_contractAddress | address | Address of options contract |
| \_optionId        | uint256 | Option ID                   |
| \_epoch           | uint256 | Epoch                       |
| \_nftToken        | address | NFT Token Address           |
| \_strikePrice     | uint256 | Strike Price                |
| \_start           | uint256 | Start Time                  |
| \_expiry          | uint256 | Expiry Time                 |

### emitPutOptionCreatedEvent

```solidity
function emitPutOptionCreatedEvent(address _contractAddress, uint256 _optionId, uint256 _epoch, address _nftToken, uint256 _strikePrice, uint256 _start, uint256 _expiry) external
```

Proxy function to emit event from options contract

#### Parameters

| Name              | Type    | Description                 |
| ----------------- | ------- | --------------------------- |
| \_contractAddress | address | Address of options contract |
| \_optionId        | uint256 | Option ID                   |
| \_epoch           | uint256 | Epoch                       |
| \_nftToken        | address | NFT Token Address           |
| \_strikePrice     | uint256 | Strike Price                |
| \_start           | uint256 | Start Time                  |
| \_expiry          | uint256 | Expiry Time                 |

### emitBoughtEvent

```solidity
function emitBoughtEvent(address _contractAddress, address _user, uint256 _order, uint256 _amount, uint256 _premium, uint256 _timestamp, uint256 _epoch) external
```

Proxy function to emit event from options contract

#### Parameters

| Name              | Type    | Description                 |
| ----------------- | ------- | --------------------------- |
| \_contractAddress | address | Address of options contract |
| \_user            | address | User Address                |
| \_order           | uint256 | Order ID                    |
| \_amount          | uint256 | Amount                      |
| \_premium         | uint256 | Premium                     |
| \_timestamp       | uint256 | Timestamp                   |
| \_epoch           | uint256 | Epoch                       |

### emitExerciseEvent

```solidity
function emitExerciseEvent(address _contractAddress, address _user, uint256 _id, uint256 _pnl, bool _profit) external
```

Proxy function to emit event from options contract

#### Parameters

| Name              | Type    | Description                 |
| ----------------- | ------- | --------------------------- |
| \_contractAddress | address | Address of options contract |
| \_user            | address | User Address                |
| \_id              | uint256 | Order ID                    |
| \_pnl             | uint256 | PnL                         |
| \_profit          | bool    | Profit                      |

## BluebirdOptions

_Only can be issued by the BluebirdManager_

### nftFeed

```solidity
contract AggregatorV3Interface nftFeed
```

Price feed interface used for getting the latest price

### nftToken

```solidity
contract IERC20 nftToken
```

Fractionalised NFT Token

### bluebirdManager

```solidity
contract IBluebirdManager bluebirdManager
```

Bluebird Manager contract

### optionPricing

```solidity
contract IOptionPricing optionPricing
```

Option pricing contract

### EXPIRY

```solidity
uint256 EXPIRY
```

Expiry time of options in seconds

### startTimeEpoch

```solidity
uint256 startTimeEpoch
```

Start time of epoch in seconds

### interval

```solidity
uint256 interval
```

Interval of chainlink round update

### epoch

```solidity
uint256 epoch
```

Current epoch number

### liquidityProvidingTime

```solidity
uint256 liquidityProvidingTime
```

Amount of time in which market makers can provide liquidity

### currentId

```solidity
uint256 currentId
```

Current Id of options

### maxBuyCall

```solidity
uint256 maxBuyCall
```

Maximum amount of options that a user can buy for calls

### maxBuyPut

```solidity
uint256 maxBuyPut
```

Maximum amount of options that a user can buy for puts

### userDeposits

```solidity
mapping(address => mapping(uint256 => uint256)) userDeposits
```

Mapping of user to amount of NFT tokens or ETH deposited to providing liquidity

### nftOpts

```solidity
mapping(uint256 => struct IBluebirdOptions.Option) nftOpts
```

Mapping to track each option

### userToOptionIdToAmount

```solidity
mapping(address => mapping(uint256 => uint256)) userToOptionIdToAmount
```

Mapping of user to option id to amount of options bought

### exercised

```solidity
mapping(address => mapping(uint256 => bool)) exercised
```

Mapping which checks if current id has been exercised

### epochToStrikePrices

```solidity
mapping(uint256 => mapping(bool => uint256[])) epochToStrikePrices
```

Mapping of epoch to isPut to strike prices

### constructor

```solidity
constructor(contract AggregatorV3Interface _nftFeed, contract IBB20 _nftToken, address _bluebirdManager, contract IOptionPricing _optionsPricing, address _owner) public
```

Constructor of Bluebird Options

#### Parameters

| Name              | Type                           | Description               |
| ----------------- | ------------------------------ | ------------------------- |
| \_nftFeed         | contract AggregatorV3Interface | Price feed of NFT         |
| \_nftToken        | contract IBB20                 | Fractionalised NFT Token  |
| \_bluebirdManager | address                        | Bluebird Manager contract |
| \_optionsPricing  | contract IOptionPricing        | Option pricing contract   |
| \_owner           | address                        | Owner of contract         |

### setLiquidityProvidingTime

```solidity
function setLiquidityProvidingTime(uint256 _liquidityProvidingTime) external
```

Set liquidity providing time

#### Parameters

| Name                     | Type    | Description               |
| ------------------------ | ------- | ------------------------- |
| \_liquidityProvidingTime | uint256 | Time to provide liquidity |

### setExpiry

```solidity
function setExpiry(uint256 _expiry) external
```

Set expiry

#### Parameters

| Name     | Type    | Description       |
| -------- | ------- | ----------------- |
| \_expiry | uint256 | Expiry of options |

### setInterval

```solidity
function setInterval(uint256 _interval) external
```

Set interval

#### Parameters

| Name       | Type    | Description                        |
| ---------- | ------- | ---------------------------------- |
| \_interval | uint256 | interval of chainlink round update |

### \_calculateStrikePrices

```solidity
function _calculateStrikePrices(uint256 _floorPrice, bool _isPut) internal pure returns (uint256[])
```

Function to calculate strike prices

#### Parameters

| Name         | Type    | Description                   |
| ------------ | ------- | ----------------------------- |
| \_floorPrice | uint256 | Floor price of NFT            |
| \_isPut      | bool    | Whether option is put or call |

### startEpoch

```solidity
function startEpoch() public
```

Function to start epoch

### writeOption

```solidity
function writeOption() public
```

Writes options

_Only owner/controller should be able to trigger this_

### getPremium

```solidity
function getPremium(uint256 _id) public view returns (uint256)
```

Get premium of an option

#### Parameters

| Name | Type    | Description    |
| ---- | ------- | -------------- |
| \_id | uint256 | Id of contract |

### getNftPrice

```solidity
function getNftPrice() public view returns (uint256)
```

Returns the price of NFT from oracle

#### Return Values

| Name | Type    | Description  |
| ---- | ------- | ------------ |
| [0]  | uint256 | Price of NFT |

### getStage

```solidity
function getStage() public view returns (uint256 _stage)
```

Get current stage of contract

#### Return Values

| Name    | Type    | Description       |
| ------- | ------- | ----------------- |
| \_stage | uint256 | Stage of contract |

### getHistoricalPrices

```solidity
function getHistoricalPrices() public view returns (uint256[])
```

Returns the historical prices of NFT

#### Return Values

| Name | Type      | Description              |
| ---- | --------- | ------------------------ |
| [0]  | uint256[] | Historical prices of NFT |

### getStrikes

```solidity
function getStrikes(uint256 _epoch, bool _isPut) external view returns (uint256[])
```

Returns the strike prices of an epoch

#### Return Values

| Name | Type      | Description                             |
| ---- | --------- | --------------------------------------- |
| [0]  | uint256[] | uint256[] memory Array of strike prices |

### depositNftToken

```solidity
function depositNftToken(uint256 amount) public
```

Provide liquidity by depositing NFT tokens

#### Parameters

| Name   | Type    | Description                     |
| ------ | ------- | ------------------------------- |
| amount | uint256 | Amount of NFT tokens to deposit |

### depositETH

```solidity
function depositETH() public payable
```

Provide liquidity by depositing ETH

### buy

```solidity
function buy(uint256 _id, uint256 _amount) external
```

Buy an option based on `_id`

#### Parameters

| Name     | Type    | Description              |
| -------- | ------- | ------------------------ |
| \_id     | uint256 | Index of the option      |
| \_amount | uint256 | Amount of options to buy |

### calculateAmountETH

```solidity
function calculateAmountETH(uint256 _id) public view returns (uint256)
```

Calculate amount of ETH to be received when exercising an option, for calls only

#### Parameters

| Name | Type    | Description         |
| ---- | ------- | ------------------- |
| \_id | uint256 | Index of the option |

#### Return Values

| Name | Type    | Description                  |
| ---- | ------- | ---------------------------- |
| [0]  | uint256 | Amount of ETH to be received |

### exercise

```solidity
function exercise(uint256 _id) external payable
```

Exercise an option based on `_id`

#### Parameters

| Name | Type    | Description              |
| ---- | ------- | ------------------------ |
| \_id | uint256 | Id of option to exercise |

## IBB20

_Only can be issued by the BluebirdGrinder_

### Minted

```solidity
event Minted(address to, uint256 amount)
```

### mint

```solidity
function mint(address _receipient, uint256 _amount) external
```

_Mint BB20 Tokens_

### burn

```solidity
function burn(uint256 amount) external returns (bool)
```

Burn `amount` tokens and decreasing the total supply.

#### Parameters

| Name   | Type    | Description              |
| ------ | ------- | ------------------------ |
| amount | uint256 | Amount of tokens to burn |
