import { Address, BigInt, log } from "@graphprotocol/graph-ts";
import { Collection, StatsData, Token, User } from "../../generated/schema";
import { getAddressId, getName } from ".";

// import { getAddressId } from '.';

function createCollection(
  contract: Address,
  name: string,
  standard: string,
  suffix: string = ""
): void {
  let id = `${contract.toHexString()}${suffix}`;
  let collection = Collection.load(id);

  if (!collection) {
    collection = new Collection(id);

    collection.contract = contract.toHexString();
    collection.name = name;

    collection.save();
  }
}

export function createErc721Collection(contract: Address, name: string): void {
  createCollection(contract, name, "ERC721");
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
    token.save();
  }

  return token;
}

export function getUser(address: Address): User {
  let user = User.load(address.toHexString());

  if (!user) {
    user = new User(address.toHexString());
    user.save();
  }

  return user;
}
