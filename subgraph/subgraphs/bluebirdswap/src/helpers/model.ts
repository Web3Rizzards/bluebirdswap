import { Address, BigInt, log } from "@graphprotocol/graph-ts";
import { Collection, Token } from "../../generated/schema";

import { getAddressId } from ".";

// import { getAddressId } from '.';

function createCollection(
  contract: Address,
  name: string,
  symbol: string,
  standard: string,
  suffix: string = ""
): void {
  let id = `${contract.toHexString()}${suffix}`;
  let collection = Collection.load(id);

  if (!collection) {
    collection = new Collection(id);

    collection.contract = contract;
    collection.symbol = symbol;
    collection.name = name;

    collection.save();
  }
}

export function createErc721Collection(
  contract: Address,
  name: string,
  symbol: string
): void {
  createCollection(contract, name, symbol, "ERC721");
}

export function getCollection(id: string): Collection {
  let collection = Collection.load(id);

  // Should never happen, famous last words
  if (!collection) {
    collection = new Collection(id);

    log.warning("Unknown collection: {}", [id]);
  }

  return collection;
}

export function getToken(contract: Address, tokenId: BigInt): Token {
  let id = getAddressId(contract, tokenId);
  let token = Token.load(id);

  if (!token) {
    token = new Token(id);

    let collectionId = contract.toHexString();
    let collection = getCollection(collectionId);

    token.collection = collection.id;
    token.name = `${collection.name} #${tokenId.toString()}`;
    token.tokenId = tokenId;
  }

  return token;
}
