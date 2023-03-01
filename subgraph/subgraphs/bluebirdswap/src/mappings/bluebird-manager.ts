import {} from "../../generated/BluebirdManager/BluebirdManager";

import { AuctionBid } from "../../../bluebird-old/generated/schema";
import { BigInt } from "@graphprotocol/graph-ts";

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

export function handleBought(event: AuctionExtended): void {}

export function handleCallOptionCreated(event: BidIncreased): void {}

export function handleClaimed(event: NewBid): void {}

export function handlePutOptionCreated(event: OwnershipTransferred): void {}
