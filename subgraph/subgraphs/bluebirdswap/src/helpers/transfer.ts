import { Address, BigInt, TypedMap, store } from "@graphprotocol/graph-ts";
import { Collection, Token } from "../../generated/schema";
import { getToken, isZero } from ".";

import { Transfer } from "../../generated/BBYC/ERC721";

function getTime(timestamp: BigInt): i64 {
  return timestamp.toI64() * 1000;
}

export function handleTransfer721(event: Transfer): void {
  let params = event.params;

  handleTransfer(event.address, params.to, params.tokenId);
}

function handleTransfer(
  contract: Address,

  to: Address,
  tokenId: BigInt
): void {
  let token = getToken(contract, tokenId);

  token.owner = to;
  token.save();
}
