import {
  CallOptionCreated,
  Claimed,
  PutOptionCreated,
} from "../../generated/BluebirdManager/BluebirdManager";

import { BigInt } from "@graphprotocol/graph-ts";
import { Bought } from "./../../generated/BluebirdManager/BluebirdManager";

// - event: Bought(indexed address,indexed uint256,uint256,uint256,uint256,bool)
// handler: handleBought
// - event: CallOptionCreated(indexed address,indexed address,indexed address,uint256,uint256[],uint256,uint256)
// handler: handleCallOptionCreated
// - event: Claimed(indexed address,indexed uint256,uint256)
// handler: handleClaimed
// - event: OwnershipTransferred(indexed address,indexed address)
// handler: handleOwnershipTransferred
// - event: PutOptionCreated(indexed address,indexed address,indexed address,uint256,uint256[],uint256,uint256)
// handler: handlePutOptionCreated

export function handleBought(event: Bought): void {}

export function handleCallOptionCreated(event: CallOptionCreated): void {}

export function handleClaimed(event: Claimed): void {}

export function handlePutOptionCreated(event: PutOptionCreated): void {}
