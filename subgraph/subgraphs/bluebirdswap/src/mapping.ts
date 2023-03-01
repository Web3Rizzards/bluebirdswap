// import { bluebird_MARKETPLACE_ADDRESS, EXPLORER } from '@bluebird/constants';
import { Address, BigInt, TypedMap, store } from "@graphprotocol/graph-ts";
import {
  Collection,
  Fee,
  Listing,
  StakedToken,
  Token,
  UserToken,
} from "../generated/schema";
import { EXPLORER, bluebird_MARKETPLACE_ADDRESS } from "@bluebird/constants";
import {
  ItemCanceled,
  ItemListed,
  ItemSold,
  ItemUpdated,
  UpdateCollectionOwnerFee,
} from "../generated/bluebird Marketplace/bluebirdMarketplace";
// import { Staked, Unstaked } from '../generated/TreasureMarketplace/NonEscrowStaking';
import {
  TransferBatch,
  TransferSingle,
} from "../generated/bluebird Marketplace/ERC1155";
import {
  exists,
  getAddressId,
  getAllCollections,
  getCollection,
  getStats,
  getToken,
  getUser,
  getUserAddressId,
  isPaused,
  isZero,
  removeFromArray,
  removeIfExists,
} from "./helpers";

import { Transfer } from "../generated/bluebird Marketplace/ERC721";

function getListing(
  seller: Address,
  contract: Address,
  tokenId: BigInt
): Listing {
  let id = getUserAddressId(seller, contract, tokenId);
  let listing = Listing.load(id);

  if (!listing) {
    listing = new Listing(id);

    listing.seller = getUser(seller).id;
    listing.token = getAddressId(contract, tokenId);
    // listing.save();
  }

  return listing;
}

/**
 * This is a generic function that can handle both ERC1155s and ERC721s
 */
function handleTransfer(
  contract: Address,
  operator: Address,
  from: Address,
  to: Address,
  tokenId: BigInt,
  quantity: i32,
  timestamp: i64
): void {
  let user = getUser(to);
  let token = getToken(contract, tokenId);

  if (isZero(from)) {
    let collection = Collection.load(token.collection);

    // Will be null from legions collection
    if (collection != null) {
      if (collection.standard == "ERC1155") {
        let stats = getStats(token.id);

        stats.items.plus(BigInt.fromI32(quantity));
        stats.save();
      }

      let stats = getStats(collection.id);

      stats.items.plus(BigInt.fromI32(quantity));
      stats.save();
    }
  }

  let fromUserToken = UserToken.load(`${from.toHexString()}-${token.id}`);

  if (fromUserToken) {
    fromUserToken.quantity = fromUserToken.quantity.minus(
      BigInt.fromI32(quantity)
    );
    fromUserToken.save();

    if (fromUserToken.quantity.equals(BigInt.zero())) {
      removeIfExists("UserToken", fromUserToken.id);
    }

    // If token was staked we need to transfer it as well
    // const stakedToken = StakedToken.load(getStakedTokenId(from, contract, tokenId));

    // if (!isZero(to) && stakedToken) {
    //   removeIfExists('StakedToken', stakedToken.id);

    //   stakedToken.id = stakedToken.id.replace(from.toHexString(), to.toHexString());
    //   stakedToken.user = to.toHexString();

    //   stakedToken.save();
    // }
  }

  if (isZero(to)) {
    let collection = Collection.load(token.collection);

    // Will be null from legions collection
    if (collection != null) {
      if (collection.standard == "ERC1155") {
        let stats = getStats(token.id);

        // stats.burned += quantity;
        stats.burned = stats.burned.plus(BigInt.fromI32(quantity));
        // stats.items -= quantity;
        stats.items = stats.items.minus(BigInt.fromI32(quantity));

        stats.save();
      } else {
        removeIfExists("Token", token.id);
      }

      let stats = getStats(collection.id);

      // stats.burned += quantity;
      stats.burned = stats.burned.plus(BigInt.fromI32(quantity));
      // stats.items -= quantity;
      stats.items = stats.items.minus(BigInt.fromI32(quantity));

      stats.save();
    }

    removeIfExists("User", Address.zero().toHexString());

    return;
  }

  let id = `${user.id}-${token.id}`;
  let toUserToken = UserToken.load(id);

  if (!toUserToken) {
    toUserToken = new UserToken(id);

    toUserToken.collection = token.collection;
    toUserToken.quantity = BigInt.zero();
    toUserToken.token = token.id;
    toUserToken.user = user.id;
  }

  // toUserToken.quantity += quantity;
  toUserToken.quantity = toUserToken.quantity.plus(BigInt.fromI32(quantity));

  toUserToken.save();
}

function updateCollectionFloorAndTotal(id: string, timestamp: i64): void {
  let collection = getCollection(id);
  let floorPrices = new TypedMap<string, BigInt>();
  let tokenListings = new Map<string, BigInt>();
  let listings = collection.listings;
  let length = listings.length;
  let stats = getStats(id);

  stats.floorPrice = BigInt.zero();
  stats.listings = BigInt.zero();

  for (let index = 0; index < length; index++) {
    let id = listings[index];
    let listing = Listing.load(id);

    if (!listing) {
      collection.listings = removeFromArray(listings, id);
    } else {
      if (listing.status == "Active") {
        let floorPrice = stats.floorPrice;
        let pricePerItem = listing.pricePerItem;

        // Check to see if we need to expire the listing
        if (listing.expires.lt(BigInt.fromI64(timestamp))) {
          listing.status = "Expired";
          listing.save();

          continue;
        }

        if (collection.standard == "ERC1155") {
          let tokenFloorPrice = floorPrices.get(listing.token);
          let currentTokenListings = tokenListings.has(listing.token)
            ? tokenListings.get(listing.token)
            : BigInt.zero();

          tokenListings.set(
            listing.token,
            currentTokenListings.plus(listing.quantity)
          );

          if (
            !tokenFloorPrice ||
            (tokenFloorPrice && tokenFloorPrice.gt(pricePerItem))
          ) {
            floorPrices.set(listing.token, pricePerItem);
          }
        }

        if (floorPrice.isZero() || floorPrice.gt(pricePerItem)) {
          stats.floorPrice = pricePerItem;
        }

        stats.listings = stats.listings.plus(listing.quantity);
      }
    }
  }

  let entries = floorPrices.entries;

  for (let index = 0; index < entries.length; index++) {
    let entry = entries[index];
    let token = Token.load(entry.key);
    let stats = getStats(entry.key);

    stats.floorPrice = entry.value;
    stats.save();

    if (token) {
      // token.floorPrice = entry.value;
      token.save();
    }
  }

  let keys = tokenListings.keys();

  for (let index = 0; index < keys.length; index++) {
    let key = keys[index];
    let stats = getStats(key);

    stats.listings = tokenListings.get(key);
    stats.save();
  }

  collection.save();
  stats.save();
}

function normalizeTime(value: BigInt): BigInt {
  return value.toString().length == 10
    ? value.times(BigInt.fromI32(1000))
    : value;
}

function getTime(timestamp: BigInt): i64 {
  return timestamp.toI64() * 1000;
}

export function handleItemCanceled(event: ItemCanceled): void {
  // Do nothing if paused
  // if (isPaused(event)) {
  //   return;
  // }

  let params = event.params;
  let address = params.nftAddress;
  let listing = getListing(params.seller, address, params.tokenId);

  // Was invalid listing, likely a Recruit.
  if (listing.quantity == BigInt.zero()) {
    return;
  }

  removeIfExists("Listing", listing.id);

  let collection = getCollection(listing.collection);

  // Update ERC1155 stats
  if (collection.standard == "ERC1155") {
    let stats = getStats(listing.token);

    // Last listing was removed. Clear floor price.
    if (stats.listings == listing.quantity) {
      stats.floorPrice = BigInt.zero();
      stats.listings = BigInt.zero();
    }

    stats.save();
  }

  updateCollectionFloorAndTotal(
    listing.collection,
    getTime(event.block.timestamp)
  );
}

function handleItemListed(
  timestamp: BigInt,
  seller: Address,
  tokenAddress: Address,
  tokenId: BigInt,
  quantity: BigInt,
  pricePerItem: BigInt,
  expirationTime: BigInt
): void {
  let token = getToken(tokenAddress, tokenId);
  let collection = getCollection(token.collection);

  if (collection.standard == "") {
    return;
  }

  let listing = getListing(seller, tokenAddress, tokenId);

  listing.blockTimestamp = timestamp;
  listing.collection = token.collection;
  listing.expires = normalizeTime(expirationTime);
  listing.pricePerItem = pricePerItem;
  listing.quantity = quantity;
  listing.status = exists("StakedToken", listing.id) ? "Inactive" : "Active";

  listing.save();

  if (collection.listings.indexOf(listing.id) == -1) {
    collection.listings = collection.listings.concat([listing.id]);
    collection.save();
  }

  updateCollectionFloorAndTotal(collection.id, getTime(timestamp));
}

export function handleMarketplaceItemListed(event: ItemListed): void {
  // Do nothing if paused
  // This is paused is for the migration to the next version
  // if (isPaused(event)) {
  //   return;
  // }
  const params = event.params;

  // Do nothing if not a MAGIC transaction
  // if (!params.paymentToken.equals(TROVE_MAGIC_ADDRESS)) {
  //   return;
  // }

  handleItemListed(
    event.block.timestamp,
    params.seller,
    params.nftAddress,
    params.tokenId,
    params.quantity,
    params.pricePerItem,
    params.expirationTime
  );
}

function handleItemSold(
  transactionHash: string,
  timestamp: BigInt,
  seller: Address,
  buyer: Address,
  tokenAddress: Address,
  tokenId: BigInt,
  quantity: i32
): void {
  let listing = getListing(seller, tokenAddress, tokenId);

  // Was invalid listing, likely a Recruit. Should never happen as contract would revert the transfer anyways.
  if (listing.quantity.equals(BigInt.zero())) {
    return;
  }

  listing.quantity = listing.quantity.minus(BigInt.fromI32(quantity));

  if (listing.quantity.equals(BigInt.zero()) || quantity == 0) {
    // Remove sold listing.
    removeIfExists("Listing", listing.id);
  } else {
    listing.save();
  }

  let hash = transactionHash;
  let sold = getListing(seller, tokenAddress, tokenId);

  sold.id = `${sold.id}-${hash}`;
  sold.blockTimestamp = timestamp;
  sold.buyer = getUser(buyer).id;
  sold.collection = listing.collection;
  sold.expires = BigInt.zero();
  sold.pricePerItem = listing.pricePerItem;
  sold.quantity = BigInt.fromI32(quantity);
  sold.status = quantity == 0 ? "Invalid" : "Sold";
  sold.transactionLink = `https://${EXPLORER}/tx/${hash}`;
  sold.token = listing.token;

  sold.save();

  let collection = getCollection(listing.collection);
  let stats = getStats(collection.stats);

  stats.sales = stats.sales.plus(BigInt.fromI32(quantity == 0 ? 0 : 1));
  // stats.sales = stats.sales += quantity == 0 ? 0 : 1;
  stats.volume = stats.volume.plus(
    listing.pricePerItem.times(BigInt.fromI32(quantity))
  );

  // stats.sales = collection.totalSales.toI32();

  // TODO: Not sure if this is needed, but put it in for now.
  if (listing.quantity.equals(BigInt.zero()) || quantity == 0) {
    collection.listings = removeFromArray(collection.listings, listing.id);
  }

  collection.save();
  stats.save();

  // Update ERC1155 stats
  if (collection.standard == "ERC1155") {
    let stats = getStats(listing.token);

    stats.sales = stats.sales.plus(BigInt.fromI32(1));
    stats.volume = stats.volume.plus(
      listing.pricePerItem.times(BigInt.fromI32(quantity))
    );

    // Last listing was removed. Clear floor price.
    if (stats.listings == BigInt.fromI32(quantity)) {
      stats.floorPrice = BigInt.zero();
      stats.listings = BigInt.zero();
    }

    stats.save();
  }

  updateCollectionFloorAndTotal(collection.id, getTime(timestamp));
}

export function handleMarketplaceItemSold(event: ItemSold): void {
  const params = event.params;

  // Do nothing if not a MAGIC transaction
  // if (!params.paymentToken.equals(TROVE_MAGIC_ADDRESS)) {
  //   return;
  // }

  // const buyer = params.buyer.equals(MARKETPLACE_BUYER_ADDRESS) ? event.transaction.from : params.buyer;
  const buyer = event.transaction.from;

  handleItemSold(
    event.transaction.hash.toHexString(),
    event.block.timestamp,
    params.seller,
    buyer,
    params.nftAddress,
    params.tokenId,
    params.quantity.toI32()
  );
}

function handleItemUpdated(
  timestamp: BigInt,
  seller: Address,
  tokenAddress: Address,
  tokenId: BigInt,
  quantity: BigInt,
  pricePerItem: BigInt,
  expirationTime: BigInt
): void {
  let listing = getListing(seller, tokenAddress, tokenId);

  // Was invalid listing, likely a Recruit
  if (listing.quantity.equals(BigInt.zero())) {
    return;
  }

  if (!listing.pricePerItem.equals(pricePerItem)) {
    listing.blockTimestamp = timestamp;
  }

  listing.expires = normalizeTime(expirationTime);
  listing.status = exists("StakedToken", listing.id) ? "Inactive" : "Active";
  listing.quantity = quantity;
  listing.pricePerItem = pricePerItem;

  // Bug existed in contract that allowed quantity to be updated to 0, but then couldn't be sold.
  // Remove this listing as it is invalid.
  if (listing.quantity.equals(BigInt.zero())) {
    store.remove("Listing", listing.id);
  } else {
    listing.save();
  }

  updateCollectionFloorAndTotal(listing.collection, getTime(timestamp));
}

export function handleMarketplaceItemUpdated(event: ItemUpdated): void {
  // Do nothing if paused
  // if (isPaused(event)) {
  //   return;
  // }

  const params = event.params;

  // Do nothing if not a MAGIC transaction
  // if (!params.paymentToken.equals(TROVE_MAGIC_ADDRESS)) {
  //   return;
  // }
  handleItemUpdated(
    event.block.timestamp,
    params.seller,
    params.nftAddress,
    params.tokenId,
    params.quantity,
    params.pricePerItem,
    params.expirationTime
  );
}

// // export function handleOracleUpdate(event: UpdateOracle): void {
// //   // Safety first
// //   if (event.params.oracle.notEqual(Address.zero())) {
// //     return;
// //   }

// //   // Cancel all listings.
// //   let collections = getAllCollections();
// //   let length = collections.length;

// //   for (let index = 0; index < length; index++) {
// //     let id = collections[index];

// //     // Should never happen, but cleans up warnings in test.
// //     if (!exists('Collection', id)) {
// //       continue;
// //     }

// //     let collection = getCollection(id);

// //     let listings = collection.listings.filter((item) => item.split('-').length == 3);
// //     let innerLength = listings.length;

// //     for (let innerIndex = 0; innerIndex < innerLength; innerIndex++) {
// //       store.remove('Listing', listings[innerIndex]);
// //     }

// //     let stats = getStats(id);

// //     collection.floorPrice = stats.floorPrice = BigInt.zero();
// //     collection.listings = [];
// //     collection.totalListings = stats.listings = 0;

// //     collection.save();
// //     stats.save();

// //     if (collection.standard == 'ERC1155') {
// //       for (let tokenIndex = 1; tokenIndex < 165; tokenIndex++) {
// //         let tokenId = `${collection.id}-0x${tokenIndex.toString(16)}`;

// //         if (exists('Token', tokenId)) {
// //           let token = Token.load(tokenId);

// //           if (!token) {
// //             continue;
// //           }

// //           let stats = getStats(tokenId);

// //           token.floorPrice = stats.floorPrice = BigInt.zero();
// //           token.save();

// //           stats.listings = 0;
// //           stats.save();
// //         }
// //       }
// //     }
// //   }
// // }

export function handleUpdateCollectionOwnerFee(
  event: UpdateCollectionOwnerFee
): void {
  const params = event.params;
  const id = params.collection.toHexString();

  let fee = Fee.load(id);

  if (!fee) {
    fee = new Fee(id);

    fee.collection = id;
  }

  fee.fee = params.fee
    .divDecimal(BigInt.fromI32(10_000).toBigDecimal())
    .toString();
  fee.save();
}

export function handleTransfer721(event: Transfer): void {
  let params = event.params;

  handleTransfer(
    event.address,
    Address.zero(),
    params.from,
    params.to,
    params.tokenId,
    1,
    getTime(event.block.timestamp)
  );
}

export function handleTransferBatch(event: TransferBatch): void {
  let params = event.params;
  let ids = params.ids;
  let amounts = params.values;
  let length = ids.length;

  for (let index = 0; index < length; index++) {
    let id = ids[index];

    // if (event.address.equals(TREASURE_ADDRESS) && id.isZero()) {
    //   continue;
    // }

    handleTransfer(
      event.address,
      params.operator,
      params.from,
      params.to,
      id,
      amounts[index].toI32(),
      getTime(event.block.timestamp)
    );
  }
}

export function handleTransferSingle(event: TransferSingle): void {
  let params = event.params;

  // if (event.address.equals(TREASURE_ADDRESS) && params.id.isZero()) {
  //   return;
  // }

  handleTransfer(
    event.address,
    params.operator,
    params.from,
    params.to,
    params.id,
    params.value.toI32(),
    getTime(event.block.timestamp)
  );
}
