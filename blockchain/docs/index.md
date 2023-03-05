# Solidity API

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

| Name | Type | Description |
| ---- | ---- | ----------- |
| _name | string | Name of the token |
| _symbol | string | Symbol of the token |
| _grinder | address | Address of the BluebirdGrinder contract |

### mint

```solidity
function mint(address _receipient, uint256 _amount) external
```

Mint BB20 Tokens

_Only can be called by the BluebirdGrinder_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _receipient | address | Address of the receipient |
| _amount | uint256 | Amount of tokens to mint |

### burn

```solidity
function burn(uint256 amount) external returns (bool)
```

Burn `amount` tokens and decreasing the total supply.

_Only can be called by the BluebirdGrinder_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | Amount of tokens to burn |

### _isFactory

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

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Address of NFT collection |
| _tokenId | uint256 | Token Id of NFT to fractionalize |

### reconstructNFT

```solidity
function reconstructNFT(address _collectionAddress, uint256 _tokenId) external
```

Function to reconstruct NFTs from BB20 tokens

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Address of NFT collection |
| _tokenId | uint256 | Token Id of NFT to reconstruct |

### whitelistNFT

```solidity
function whitelistNFT(address _collectionAddress) external
```

Function to whitelist NFT collection

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Address of NFT collection |

### getTokenFromCollection

```solidity
function getTokenFromCollection(address _collectionAddress) external view returns (contract IBB20)
```

Function to get token address from collection address

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Address of NFT collection |

### getIds

```solidity
function getIds(address _collectionAddress) external view returns (uint256[])
```

Function to get all token ids from collection address that are in the contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Address of NFT collection |

### concatenate

```solidity
function concatenate(string _a, string _b) internal pure returns (string)
```

Returns a concatenated string of a and b

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _a | string | string a |
| _b | string | string b |

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

| Name | Type | Description |
| ---- | ---- | ----------- |
| _optionPricing | contract IOptionPricing | Option Pricing Contract |
| _grinder | contract IBluebirdGrinder | Bluebird Grinder Contract |

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

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Collection Address |
| _nftFeedAddress | address | Chainlink Feed Address |

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

| Name | Type | Description |
| ---- | ---- | ----------- |
| _contractAddress | address | Address of options contract |
| _optionId | uint256 | Option ID |
| _epoch | uint256 | Epoch |
| _nftToken | address | NFT Token Address |
| _strikePrice | uint256 | Strike Price |
| _start | uint256 | Start Time |
| _expiry | uint256 | Expiry Time |

### emitPutOptionCreatedEvent

```solidity
function emitPutOptionCreatedEvent(address _contractAddress, uint256 _optionId, uint256 _epoch, address _nftToken, uint256 _strikePrice, uint256 _start, uint256 _expiry) external
```

Proxy function to emit event from options contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _contractAddress | address | Address of options contract |
| _optionId | uint256 | Option ID |
| _epoch | uint256 | Epoch |
| _nftToken | address | NFT Token Address |
| _strikePrice | uint256 | Strike Price |
| _start | uint256 | Start Time |
| _expiry | uint256 | Expiry Time |

### emitBoughtEvent

```solidity
function emitBoughtEvent(address _contractAddress, address _user, uint256 _order, uint256 _amount, uint256 _premium, uint256 _timestamp, uint256 _epoch) external
```

Proxy function to emit event from options contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _contractAddress | address | Address of options contract |
| _user | address | User Address |
| _order | uint256 | Order ID |
| _amount | uint256 | Amount |
| _premium | uint256 | Premium |
| _timestamp | uint256 | Timestamp |
| _epoch | uint256 | Epoch |

### emitExerciseEvent

```solidity
function emitExerciseEvent(address _contractAddress, address _user, uint256 _id, uint256 _pnl, bool _profit) external
```

Proxy function to emit event from options contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _contractAddress | address | Address of options contract |
| _user | address | User Address |
| _id | uint256 | Order ID |
| _pnl | uint256 | PnL |
| _profit | bool | Profit |

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

| Name | Type | Description |
| ---- | ---- | ----------- |
| _nftFeed | contract AggregatorV3Interface | Price feed of NFT |
| _nftToken | contract IBB20 | Fractionalised NFT Token |
| _bluebirdManager | address | Bluebird Manager contract |
| _optionsPricing | contract IOptionPricing | Option pricing contract |
| _owner | address | Owner of contract |

### setLiquidityProvidingTime

```solidity
function setLiquidityProvidingTime(uint256 _liquidityProvidingTime) external
```

Set liquidity providing time

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _liquidityProvidingTime | uint256 | Time to provide liquidity |

### setExpiry

```solidity
function setExpiry(uint256 _expiry) external
```

Set expiry

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _expiry | uint256 | Expiry of options |

### setInterval

```solidity
function setInterval(uint256 _interval) external
```

Set interval

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _interval | uint256 | interval of chainlink round update |

### _calculateStrikePrices

```solidity
function _calculateStrikePrices(uint256 _floorPrice, bool _isPut) internal pure returns (uint256[])
```

Function to calculate strike prices

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _floorPrice | uint256 | Floor price of NFT |
| _isPut | bool | Whether option is put or call |

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

| Name | Type | Description |
| ---- | ---- | ----------- |
| _id | uint256 | Id of contract |

### getNftPrice

```solidity
function getNftPrice() public view returns (uint256)
```

Returns the price of NFT from oracle

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Price of NFT |

### getStage

```solidity
function getStage() public view returns (uint256 _stage)
```

Get current stage of contract

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| _stage | uint256 | Stage of contract |

### getHistoricalPrices

```solidity
function getHistoricalPrices() public view returns (uint256[])
```

Returns the historical prices of NFT

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256[] | Historical prices of NFT |

### getStrikes

```solidity
function getStrikes(uint256 _epoch, bool _isPut) external view returns (uint256[])
```

Returns the strike prices of an epoch

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256[] | uint256[] memory Array of strike prices |

### depositNftToken

```solidity
function depositNftToken(uint256 amount) public
```

Provide liquidity by depositing NFT tokens

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
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

| Name | Type | Description |
| ---- | ---- | ----------- |
| _id | uint256 | Index of the option |
| _amount | uint256 | Amount of options to buy |

### calculateAmountETH

```solidity
function calculateAmountETH(uint256 _id) public view returns (uint256)
```

Calculate amount of ETH to be received when exercising an option, for calls only

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _id | uint256 | Index of the option |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Amount of ETH to be received |

### exercise

```solidity
function exercise(uint256 _id) external payable
```

Exercise an option based on `_id`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _id | uint256 | Id of option to exercise |

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

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | Amount of tokens to burn |

## IBluebirdGrinder

The Bluebird Grinder will break down an NFT into shards

### Redeemed

```solidity
event Redeemed(address _collectionAddress, uint256 _tokenId, address _to)
```

### Fractionalised

```solidity
event Fractionalised(address _collectionAddress, address _nftTokenAddress, uint256 _tokenId, address _to)
```

### fractionalizeNFT

```solidity
function fractionalizeNFT(address _collectionAddress, uint256 _tokenId) external
```

Convert 1 ERC721 Token into X amount of BB20 Tokens

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Collection Address |
| _tokenId | uint256 | Token Id of collection address |

### reconstructNFT

```solidity
function reconstructNFT(address _collectionAddress, uint256 _tokenId) external
```

Convert X amount of BB20 Tokens into 1 ERC721 Token

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Collection address of the fractionalized NFT |
| _tokenId | uint256 | Token ID of choice in the vaule |

### whitelistNFT

```solidity
function whitelistNFT(address _collectionAddress) external
```

Whitelist NFT Collection

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Address of the NFT collection to be whitelisted |

### getTokenFromCollection

```solidity
function getTokenFromCollection(address _collectionAddress) external view returns (contract IBB20)
```

Check if BB20 token exists given collection address

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Address of the NFT collection |

## IBluebirdManager

The Bluebird Options Manager

### CallOptionCreated

```solidity
event CallOptionCreated(address _contractAddress, uint256 _optionId, uint256 _epoch, address _nftToken, uint256 _strikePrice, uint256 _start, uint256 _expiry)
```

Emit when Call Option Contract is Created

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _contractAddress | address | Address of the contract created |
| _optionId | uint256 | Option Id |
| _epoch | uint256 | Epoch of the option |
| _nftToken | address | Address of the bb20 token |
| _strikePrice | uint256 | Strike Price |
| _start | uint256 | Start time of epoch |
| _expiry | uint256 | End time of epoch |

### PutOptionCreated

```solidity
event PutOptionCreated(address _contractAddress, uint256 _optionId, uint256 _epoch, address _nftToken, uint256 _strikePrice, uint256 _start, uint256 _expiry)
```

Emit when Put option contract is Created

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _contractAddress | address | Address of the contract created |
| _optionId | uint256 | Option Id |
| _epoch | uint256 | Epoch of the option |
| _nftToken | address | Address of the bb20 token |
| _strikePrice | uint256 | Strike Price |
| _start | uint256 | Start time of epoch |
| _expiry | uint256 | End time of epoch |

### Bought

```solidity
event Bought(address _contractAddress, address _user, uint256 _optionId, uint256 _amount, uint256 _premium, uint256 _timestamp, uint256 _epoch)
```

Emitted when an option is bought

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _contractAddress | address | Address of the contract |
| _user | address | User's address |
| _optionId | uint256 | Option Index |
| _amount | uint256 | Lots purchased |
| _premium | uint256 | Premium paid |
| _timestamp | uint256 | Timestamp of purchase |
| _epoch | uint256 | Epoch of the option |

### Exercised

```solidity
event Exercised(address _contractAddress, address _user, uint256 _id, uint256 _profits, bool _profit)
```

Emitted when a user claims profits

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _contractAddress | address | Address of the contract |
| _user | address | User's address |
| _id | uint256 | id of option |
| _profits | uint256 | profit or loss number |
| _profit | bool | true for profit and false for loss -> this indicates _pnl is positive or negative |

### OptionContractCreated

```solidity
event OptionContractCreated(address _opt, address _collectionAddress, address _nftToken)
```

Emitted when new option contract is created

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _opt | address | Address of the option contract |
| _collectionAddress | address | Address of the collection |
| _nftToken | address | Address of the bb20 token |

### createOptions

```solidity
function createOptions(address _collectionAddress, address _nftFeedAddress) external
```

Create a New Call and Put Options for the epoch

_Can only create when previous epoch has expired
Increment epoch
Must be whitelisted NFT collection_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collectionAddress | address | Address of the NFT Collection |
| _nftFeedAddress | address | Address of the NFT Oracle Feed from Chainlink |

### emitCallOptionCreatedEvent

```solidity
function emitCallOptionCreatedEvent(address _contractAddress, uint256 _optionId, uint256 _epoch, address _nftToken, uint256 _strikePrice, uint256 _start, uint256 _expiry) external
```

### emitPutOptionCreatedEvent

```solidity
function emitPutOptionCreatedEvent(address _contractAddress, uint256 _optionId, uint256 _epoch, address _nftToken, uint256 _strikePrice, uint256 _start, uint256 _expiry) external
```

### emitBoughtEvent

```solidity
function emitBoughtEvent(address _contractAddress, address _user, uint256 _order, uint256 _amount, uint256 _premium, uint256 _timestamp, uint256 _epoch) external
```

### emitExerciseEvent

```solidity
function emitExerciseEvent(address _contractAddress, address _user, uint256 _id, uint256 _pnl, bool _profit) external
```

## IBluebirdOptions

The Bluebird Options contract will represent a options belonging to an epoch.
The contract will contain the strike prices for the epoch
The contract will only encapsulate puts or calls only
The contract shall be named as {NFT_SYMBOL}-{EPOCH}-{PUT/CALL}

### Option

```solidity
struct Option {
  uint256 strike;
  uint256 expiry;
  uint256 amount;
  bool isPut;
}
```

### buy

```solidity
function buy(uint256 _id, uint256 _amount) external
```

Buy an option

_Option must have started
Option must not have expired
`_amount` must be less than or equal to the amount of lots available_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _id | uint256 | ID of the option |
| _amount | uint256 | Amount of lots to buy |

### exercise

```solidity
function exercise(uint256 _id) external payable
```

Claim profits, if any

_Must be owner of order_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _id | uint256 | Order Index |

### getStrikes

```solidity
function getStrikes(uint256 _epoch, bool _isPut) external view returns (uint256[])
```

Get strike prices of the current contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _epoch | uint256 | Epoch of the option |
| _isPut | bool | Is the option a put option |

### getPremium

```solidity
function getPremium(uint256 _id) external view returns (uint256)
```

Get premium based on option id

## IOptionPricing

### getOptionPrice

```solidity
function getOptionPrice(bool isPut, uint256 expiry, uint256 strike, uint256 lastPrice, uint256 baseIv) external view returns (uint256)
```

## BluebirdMath

### computeStandardDeviation

```solidity
function computeStandardDeviation(uint256[] _values) internal pure returns (uint256)
```

Compute standard deviation of an array of values

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _values | uint256[] | Array of values |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Standard deviation of `_values` |

### sqrt

```solidity
function sqrt(uint256 x) internal pure returns (uint256)
```

Square root function

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | uint256 | Input x |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Square root of `x` |

## SetUtils

### toArray

```solidity
function toArray(struct EnumerableSet.AddressSet _set) internal view returns (address[])
```

_Converst an iterable set of addresses to a corresponding array_

### toArray

```solidity
function toArray(struct EnumerableSet.UintSet _set) internal view returns (uint256[])
```

_Converst an iterable set of uint to a corresponding array_

## OptionPricing

### volatilityCap

```solidity
uint256 volatilityCap
```

### minOptionPricePercentage

```solidity
uint256 minOptionPricePercentage
```

### constructor

```solidity
constructor(uint256 _volatilityCap, uint256 _minOptionPricePercentage) public
```

### updateVolatilityCap

```solidity
function updateVolatilityCap(uint256 _volatilityCap) external returns (bool)
```

updates volatility cap for an option pool

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _volatilityCap | uint256 | the new volatility cap |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | whether volatility cap was updated |

### updateMinOptionPricePercentage

```solidity
function updateMinOptionPricePercentage(uint256 _minOptionPricePercentage) external returns (bool)
```

updates % of the price of asset which is the minimum option price possible

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _minOptionPricePercentage | uint256 | the new % |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | whether % was updated |

### getOptionPrice

```solidity
function getOptionPrice(bool isPut, uint256 expiry, uint256 strike, uint256 lastPrice, uint256 volatility) external view returns (uint256)
```

computes the option price (with liquidity multiplier)

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| isPut | bool | is put option |
| expiry | uint256 | expiry timestamp |
| strike | uint256 | strike price |
| lastPrice | uint256 | current price |
| volatility | uint256 | volatility |

## ABDKMathQuad

Smart contract library of mathematical functions operating with IEEE 754
quadruple-precision binary floating-point numbers (quadruple precision
numbers).  As long as quadruple precision numbers are 16-bytes long, they are
represented by bytes16 type.

### fromInt

```solidity
function fromInt(int256 x) internal pure returns (bytes16)
```

Convert signed 256-bit integer number into quadruple precision number.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | signed 256-bit integer number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### toInt

```solidity
function toInt(bytes16 x) internal pure returns (int256)
```

Convert quadruple precision number into signed 256-bit integer number
rounding towards zero.  Revert on overflow.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int256 | signed 256-bit integer number |

### fromUInt

```solidity
function fromUInt(uint256 x) internal pure returns (bytes16)
```

Convert unsigned 256-bit integer number into quadruple precision number.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | uint256 | unsigned 256-bit integer number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### toUInt

```solidity
function toUInt(bytes16 x) internal pure returns (uint256)
```

Convert quadruple precision number into unsigned 256-bit integer number
rounding towards zero.  Revert on underflow.  Note, that negative floating
point numbers in range (-1.0 .. 0.0) may be converted to unsigned integer
without error, because they are rounded to zero.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | unsigned 256-bit integer number |

### from128x128

```solidity
function from128x128(int256 x) internal pure returns (bytes16)
```

Convert signed 128.128 bit fixed point number into quadruple precision
number.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | signed 128.128 bit fixed point number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### to128x128

```solidity
function to128x128(bytes16 x) internal pure returns (int256)
```

Convert quadruple precision number into signed 128.128 bit fixed point
number.  Revert on overflow.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int256 | signed 128.128 bit fixed point number |

### from64x64

```solidity
function from64x64(int128 x) internal pure returns (bytes16)
```

Convert signed 64.64 bit fixed point number into quadruple precision
number.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int128 | signed 64.64 bit fixed point number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### to64x64

```solidity
function to64x64(bytes16 x) internal pure returns (int128)
```

Convert quadruple precision number into signed 64.64 bit fixed point
number.  Revert on overflow.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int128 | signed 64.64 bit fixed point number |

### fromOctuple

```solidity
function fromOctuple(bytes32 x) internal pure returns (bytes16)
```

Convert octuple precision number into quadruple precision number.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes32 | octuple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### toOctuple

```solidity
function toOctuple(bytes16 x) internal pure returns (bytes32)
```

Convert quadruple precision number into octuple precision number.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes32 | octuple precision number |

### fromDouble

```solidity
function fromDouble(bytes8 x) internal pure returns (bytes16)
```

Convert double precision number into quadruple precision number.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes8 | double precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### toDouble

```solidity
function toDouble(bytes16 x) internal pure returns (bytes8)
```

Convert quadruple precision number into double precision number.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes8 | double precision number |

### isNaN

```solidity
function isNaN(bytes16 x) internal pure returns (bool)
```

Test whether given quadruple precision number is NaN.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if x is NaN, false otherwise |

### isInfinity

```solidity
function isInfinity(bytes16 x) internal pure returns (bool)
```

Test whether given quadruple precision number is positive or negative
infinity.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if x is positive or negative infinity, false otherwise |

### sign

```solidity
function sign(bytes16 x) internal pure returns (int8)
```

Calculate sign of x, i.e. -1 if x is negative, 0 if x if zero, and 1 if x
is positive.  Note that sign (-0) is zero.  Revert if x is NaN.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int8 | sign of x |

### cmp

```solidity
function cmp(bytes16 x, bytes16 y) internal pure returns (int8)
```

Calculate sign (x - y).  Revert if either argument is NaN, or both
arguments are infinities of the same sign.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |
| y | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int8 | sign (x - y) |

### eq

```solidity
function eq(bytes16 x, bytes16 y) internal pure returns (bool)
```

Test whether x equals y.  NaN, infinity, and -infinity are not equal to
anything.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |
| y | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if x equals to y, false otherwise |

### add

```solidity
function add(bytes16 x, bytes16 y) internal pure returns (bytes16)
```

Calculate x + y.  Special values behave in the following way:

NaN + x = NaN for any x.
Infinity + x = Infinity for any finite x.
-Infinity + x = -Infinity for any finite x.
Infinity + Infinity = Infinity.
-Infinity + -Infinity = -Infinity.
Infinity + -Infinity = -Infinity + Infinity = NaN.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |
| y | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### sub

```solidity
function sub(bytes16 x, bytes16 y) internal pure returns (bytes16)
```

Calculate x - y.  Special values behave in the following way:

NaN - x = NaN for any x.
Infinity - x = Infinity for any finite x.
-Infinity - x = -Infinity for any finite x.
Infinity - -Infinity = Infinity.
-Infinity - Infinity = -Infinity.
Infinity - Infinity = -Infinity - -Infinity = NaN.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |
| y | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### mul

```solidity
function mul(bytes16 x, bytes16 y) internal pure returns (bytes16)
```

Calculate x * y.  Special values behave in the following way:

NaN * x = NaN for any x.
Infinity * x = Infinity for any finite positive x.
Infinity * x = -Infinity for any finite negative x.
-Infinity * x = -Infinity for any finite positive x.
-Infinity * x = Infinity for any finite negative x.
Infinity * 0 = NaN.
-Infinity * 0 = NaN.
Infinity * Infinity = Infinity.
Infinity * -Infinity = -Infinity.
-Infinity * Infinity = -Infinity.
-Infinity * -Infinity = Infinity.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |
| y | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### div

```solidity
function div(bytes16 x, bytes16 y) internal pure returns (bytes16)
```

Calculate x / y.  Special values behave in the following way:

NaN / x = NaN for any x.
x / NaN = NaN for any x.
Infinity / x = Infinity for any finite non-negative x.
Infinity / x = -Infinity for any finite negative x including -0.
-Infinity / x = -Infinity for any finite non-negative x.
-Infinity / x = Infinity for any finite negative x including -0.
x / Infinity = 0 for any finite non-negative x.
x / -Infinity = -0 for any finite non-negative x.
x / Infinity = -0 for any finite non-negative x including -0.
x / -Infinity = 0 for any finite non-negative x including -0.

Infinity / Infinity = NaN.
Infinity / -Infinity = -NaN.
-Infinity / Infinity = -NaN.
-Infinity / -Infinity = NaN.

Division by zero behaves in the following way:

x / 0 = Infinity for any finite positive x.
x / -0 = -Infinity for any finite positive x.
x / 0 = -Infinity for any finite negative x.
x / -0 = Infinity for any finite negative x.
0 / 0 = NaN.
0 / -0 = NaN.
-0 / 0 = NaN.
-0 / -0 = NaN.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |
| y | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### neg

```solidity
function neg(bytes16 x) internal pure returns (bytes16)
```

Calculate -x.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### abs

```solidity
function abs(bytes16 x) internal pure returns (bytes16)
```

Calculate |x|.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### sqrt

```solidity
function sqrt(bytes16 x) internal pure returns (bytes16)
```

Calculate square root of x.  Return NaN on negative x excluding -0.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### log_2

```solidity
function log_2(bytes16 x) internal pure returns (bytes16)
```

Calculate binary logarithm of x.  Return NaN on negative x excluding -0.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### ln

```solidity
function ln(bytes16 x) internal pure returns (bytes16)
```

Calculate natural logarithm of x.  Return NaN on negative x excluding -0.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### pow_2

```solidity
function pow_2(bytes16 x) internal pure returns (bytes16)
```

Calculate 2^x.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

### exp

```solidity
function exp(bytes16 x) internal pure returns (bytes16)
```

Calculate e^x.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | bytes16 | quadruple precision number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes16 | quadruple precision number |

## BlackScholes

This library implements the Black-Scholes model to price options.
See - https://en.wikipedia.org/wiki/Black%E2%80%93Scholes_model

_Implements the following implementation - https://cseweb.ucsd.edu/~goguen/courses/130/SayBlackScholes.html
Uses the ABDKMathQuad(https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMathQuad.md)
library to make precise calculations. It uses a DIVISOR (1e16) for maintaining precision in constants._

### OPTION_TYPE_CALL

```solidity
uint8 OPTION_TYPE_CALL
```

### OPTION_TYPE_PUT

```solidity
uint8 OPTION_TYPE_PUT
```

### DIVISOR

```solidity
uint256 DIVISOR
```

### calculate

```solidity
function calculate(uint8 optionType, uint256 price, uint256 strike, uint256 timeToExpiry, uint256 riskFreeRate, uint256 volatility) internal view returns (uint256)
```

The function that uses the Black-Scholes equation to calculate the option price
See http://en.wikipedia.org/wiki/Black%E2%80%93Scholes_model#Black-Scholes_formula
NOTE: The different parts of the equation are broken down to separate functions as using
ABDKMathQuad makes small equations verbose.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| optionType | uint8 | Type of option - 0 = call, 1 = put |
| price | uint256 | Stock price |
| strike | uint256 | Strike price |
| timeToExpiry | uint256 | Time to expiry in days |
| riskFreeRate | uint256 | Risk-free rate |
| volatility | uint256 | Volatility on the asset |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Option price based on the Black-Scholes model |

### _calculateCallTimeDecay

```solidity
function _calculateCallTimeDecay(bytes16 S, bytes16 d1, bytes16 X, bytes16 r, bytes16 T, bytes16 d2) internal pure returns (bytes16)
```

_Function to caluclate the call time decay
From the implementation page(https://cseweb.ucsd.edu/~goguen/courses/130/SayBlackScholes.html); part of the equation
( S * CND(d1)-X * Math.exp(-r * T) * CND(d2) );_

### _calculatePutTimeDecay

```solidity
function _calculatePutTimeDecay(bytes16 X, bytes16 r, bytes16 T, bytes16 d2, bytes16 S, bytes16 d1) internal pure returns (bytes16)
```

_Function to caluclate the put time decay
From the implementation page(https://cseweb.ucsd.edu/~goguen/courses/130/SayBlackScholes.html); part of the equation -
( X * Math.exp(-r * T) * CND(-d2) - S * CND(-d1) );_

### CND

```solidity
function CND(bytes16 x) internal pure returns (bytes16)
```

Normal cumulative distribution function.
See http://en.wikipedia.org/wiki/Normal_distribution#Cumulative_distribution_function
From the implementation page(https://cseweb.ucsd.edu/~goguen/courses/130/SayBlackScholes.html); part of the equation -
"k = 1 / (1 + .2316419 * x); return ( 1 - Math.exp(-x * x / 2)/ Math.sqrt(2*Math.PI) * k * (.31938153 + k * (-.356563782 + k * (1.781477937 + k * (-1.821255978 + k * 1.330274429)))) );"
NOTE: The different parts of the equation are broken down to separate functions as using
ABDKMathQuad makes small equations verbose.

### _getCNDPart2

```solidity
function _getCNDPart2(bytes16 k, bytes16 x) internal pure returns (bytes16)
```

### _getCNDPart2_1

```solidity
function _getCNDPart2_1(bytes16 x) internal pure returns (bytes16)
```

### _getCNDPart2_2

```solidity
function _getCNDPart2_2(bytes16 k) internal pure returns (bytes16)
```

### _getCNDPart2_2_1

```solidity
function _getCNDPart2_2_1(bytes16 k) internal pure returns (bytes16)
```

## MockOracle

### price

```solidity
int256 price
```

### decimals

```solidity
uint8 decimals
```

### description

```solidity
string description
```

### version

```solidity
uint256 version
```

### roundId

```solidity
uint80 roundId
```

### answers

```solidity
mapping(uint80 => int256) answers
```

### AnswerUpdated

```solidity
event AnswerUpdated(int256 current, uint256 roundId, uint256 updatedAt)
```

### constructor

```solidity
constructor(int256 _price, uint8 _decimals, string _description) public
```

### getRoundData

```solidity
function getRoundData(uint80 _roundId) public view returns (uint80, int256, uint256, uint256, uint80)
```

### latestRoundData

```solidity
function latestRoundData() public view returns (uint80, int256, uint256, uint256, uint80)
```

### setPrice

```solidity
function setPrice(int256 _price) public
```

## BBYC

### index

```solidity
uint256 index
```

### constructor

```solidity
constructor() public
```

### mint

```solidity
function mint() external
```

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

## Azuki

### index

```solidity
uint256 index
```

### constructor

```solidity
constructor() public
```

### mint

```solidity
function mint() external
```

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

## BAYC

### index

```solidity
uint256 index
```

### constructor

```solidity
constructor() public
```

### mint

```solidity
function mint() external
```

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

## HistoricalPriceCalculator

### getExpectedPrice

```solidity
function getExpectedPrice(uint256[] prices) public pure returns (uint256)
```

### getDifferences

```solidity
function getDifferences(uint256[] prices, uint256 expectedPrice) public pure returns (uint256[])
```

### getSquareDifferences

```solidity
function getSquareDifferences(uint256[] differences) public pure returns (uint256[])
```

### getSumOfSquareDifferences

```solidity
function getSumOfSquareDifferences(uint256[] squareDifferences) public pure returns (uint256)
```

### getVariance

```solidity
function getVariance(uint256[] squareDifferences, uint256 length) public pure returns (uint256)
```

### getStandardDeviation

```solidity
function getStandardDeviation(uint256 variance) public pure returns (uint256)
```

### sqrt

```solidity
function sqrt(uint256 x) internal pure returns (uint256)
```

## MockUSDC

### Minted

```solidity
event Minted(address to, uint256 amount)
```

### constructor

```solidity
constructor() public
```

### burn

```solidity
function burn(uint256 amount) external returns (bool)
```

Burn `amount` tokens and decreasing the total supply.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | Amount of tokens to burn |

### devMint

```solidity
function devMint(uint256 _amount) external
```

_Mint BB_

