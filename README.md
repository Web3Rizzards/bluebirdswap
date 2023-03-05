# BluebirdSwap Fractionalised NFT Decentralised Options Trading - Solidity API Docs

## Deployments
Goerli Testnet
| Name            | Description                                                                                           | Addresses                               |
| --------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------- |
| BluebirdManager | Manage the creation of option smart contracts                                                         | 0xcd32229b3D60990C75597009D8398367bCd77D8E                       |
| BluebirdGrinder | Fractionalize NFT and Reconstruct NFT from fragments                                                  | 0x503F5104361D4e0be9874D90d24Fdfd3c88e248F                     |
| BluebirdOptions - Azuki | Contract that holds the logic for peer-to-pool automated options writing for a single NFT collection. | 0x6e42ed27C4470aD83250Fb6947F4AfBCd6bac98e |
| BluebirdOptions - BBYC | Contract that holds the logic for peer-to-pool automated options writing for a single NFT collection. | 0x98aa30Ce2f37B230A065B5b1E39cF447122F675c |
| OptionPricing | Contract that holds the logic to price options with BlackScholes | 0x31dd4FD29b4e2DeeE184E2F05a179c922804A261 |
| MockOracle | Mock Chainlink oracle in place of any NFT price feeds that are not available on that specific chain | 0x3b2B8eD017Df41113E592fff03ab7F7Ca98d118F |
| Azuki | Mock Azuki contract, used in conjunction with actual Chainlink price feed oracle                                              | 0xE88Fc6063B09D822b12Fcab33f77e5ab6336E1c0                       |
| BBYC | Blue Bird Yacht Club contract, used as our sample NFT in this protocol                                                 | 0xd12C158F9CFf1a252B463F2c419Dca1f92872356                     |
| bbBBYC| Fractionalised BBYC nft tokens | 0x2e02E42872550329ec835c99a00ad9903d72a1DC |
| bbAzuki | Fractionalised Azuki nft tokens| 0x525bb6caFeD1b97A654b250bb0a962578A8d2cf6 |

Base Testnet
| Name            | Description                                                                                           | Addresses                               |
| --------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------- |
| BluebirdManager | Manage the creation of option smart contracts                                                         | 0xA960261A0926F02822543561f3ae0f86839b2Ea2                       |
| BluebirdGrinder | Fractionalize NFT and Reconstruct NFT from fragments                                                  | 0x4aB59d8D18298261560aFcAf780E17Dc69B877d0                     |
| BluebirdOptions - BBYC | Contract that holds the logic for peer-to-pool automated options writing for a single NFT collection. | 0xC9885Bfbc06a723d9C0627a4140B27810C1C62AB |
| OptionPricing | Contract that holds the logic to price options with BlackScholes | 0xc2a33a404e1fd76eddbF841A9327CD0e1BB4353e |
| MockOracle | Mock Chainlink oracle in place of any NFT price feeds that are not available on that specific chain | 0xfA3422b99515d78D889C0a8Ce866A8444A589fB8 |
| BBYC | Blue Bird Yacht Club contract, used as our sample NFT in this protocol                                                 | 0x07A583000b1C86b159e065D16c05fbD5A14f92A8                     |
| bbBBYC| Fractionalised BBYC nft tokens | 0x52E25E5911b2003d4cfe572f374e20d8FF313F5E |

Mumbai Testnet
| Name            | Description                                                                                           | Addresses                               |
| --------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------- |
| BluebirdManager | Manage the creation of option smart contracts                                                         | 0xbF0f6C964656D9493B831E72606E4b192AE82cA2                       |
| BluebirdGrinder | Fractionalize NFT and Reconstruct NFT from fragments                                                  | 0x7A5A68f723000b6F99863464d1C3483a4A1A549c                     |
| BluebirdOptions - BBYC | Contract that holds the logic for peer-to-pool automated options writing for a single NFT collection. | 0x547b6c1A306f341CBc46766f73D5523dA8E476F5 |
| OptionPricing | Contract that holds the logic to price options with BlackScholes | 0xd79EEB728Fe4Fb7229Fa30D0e15A5C91a1D63C63 |
| MockOracle | Mock Chainlink oracle in place of any NFT price feeds that are not available on that specific chain | 0x3F7f1ACDe99F262A9200D220Bb1839bDAbDaA8a3 |
| BBYC | Blue Bird Yacht Club contract, used as our sample NFT in this protocol                                                 | 0x77f359C9e1F5a1264B931fca77523d99a7807b50                     |
| bbBBYC| Fractionalised BBYC nft tokens | 0x7321aE89644aBD8b69e68479E5b59ada5FccDc80 |

Mantle Testnet
| Name            | Description                                                                                           | Addresses                               |
| --------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------- |
| BluebirdManager | Manage the creation of option smart contracts                                                         | 0xA960261A0926F02822543561f3ae0f86839b2Ea2                       |
| BluebirdGrinder | Fractionalize NFT and Reconstruct NFT from fragments                                                  | 0x4aB59d8D18298261560aFcAf780E17Dc69B877d0                     |
| BluebirdOptions - BBYC | Contract that holds the logic for peer-to-pool automated options writing for a single NFT collection. | 0xC9885Bfbc06a723d9C0627a4140B27810C1C62AB |
| OptionPricing | Contract that holds the logic to price options with BlackScholes | 0xc2a33a404e1fd76eddbF841A9327CD0e1BB4353e |
| MockOracle | Mock Chainlink oracle in place of any NFT price feeds that are not available on that specific chain | 0xfA3422b99515d78D889C0a8Ce866A8444A589fB8 |
| BBYC | Blue Bird Yacht Club contract, used as our sample NFT in this protocol                                                 | 0x07A583000b1C86b159e065D16c05fbD5A14f92A8                     |
| bbBBYC| Fractionalised BBYC nft tokens | 0x52E25E5911b2003d4cfe572f374e20d8FF313F5E |

Metis Testnet
| Name            | Description                                                                                           | Addresses                               |
| --------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------- |
| BluebirdManager | Manage the creation of option smart contracts                                                         | 0x9c84b49574DBBe735B1ade34DBdA06C8e055eb36                       |
| BluebirdGrinder | Fractionalize NFT and Reconstruct NFT from fragments                                                  | 0xeBCbEe60876e4481DcFBAE8A2983ebBc49AD624c                     |
| BluebirdOptions - BBYC | Contract that holds the logic for peer-to-pool automated options writing for a single NFT collection. | 0xd73df9049DE5e04a1Bb03893e0ee266f0544bf66 |
| OptionPricing | Contract that holds the logic to price options with BlackScholes | 0x1588996B29513f00C63c979A1b28b1454B1639F6 |
| MockOracle | Mock Chainlink oracle in place of any NFT price feeds that are not available on that specific chain | 0x3ca839f1E7E456464e2CEF5bd43E4e64aBFcFBff |
| BBYC | Blue Bird Yacht Club contract, used as our sample NFT in this protocol                                                 | 0xA960261A0926F02822543561f3ae0f86839b2Ea2                     |
| bbBBYC| Fractionalised BBYC nft tokens | 0x92aB41E00310077603254D0D7b4B0BD9Ef60C996 |

Scroll Alpha Testnet
| Name            | Description                                                                                           | Addresses                               |
| --------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------- |
| BluebirdManager | Manage the creation of option smart contracts                                                         | 0xB7FC58dA365D6E328362B5799ec8E9a7Ae13cA07                       |
| BluebirdGrinder | Fractionalize NFT and Reconstruct NFT from fragments                                                  | 0x05CE628bFfB7be936bB659274210AFeefd454Dff                     |
| BluebirdOptions - BBYC | Contract that holds the logic for peer-to-pool automated options writing for a single NFT collection. | 0x45947030980cE2594b766F138F3D0174f0265cB9 |
| OptionPricing | Contract that holds the logic to price options with BlackScholes | 0xe41A822fA1F2Cb9823bd4654830CE8c59754537f |
| MockOracle | Mock Chainlink oracle in place of any NFT price feeds that are not available on that specific chain | 0x7A5A68f723000b6F99863464d1C3483a4A1A549c |
| BBYC | Blue Bird Yacht Club contract, used as our sample NFT in this protocol                                                 | 0xd79EEB728Fe4Fb7229Fa30D0e15A5C91a1D63C63                     |
| bbBBYC| Fractionalised BBYC nft tokens | 0x3A29F2D351D56d5717dbc77fFca6749ee4A17Bbb |

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
