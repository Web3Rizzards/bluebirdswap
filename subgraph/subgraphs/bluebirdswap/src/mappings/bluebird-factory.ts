import {
  AuctionExtended,
  BidIncreased,
  NewBid,
  OwnershipTransferred,
  bluebirdAuction,
} from '../../generated/bluebirdAuction/bluebirdAuction';

import { AuctionBid } from '../../../bluebird-old/generated/schema';
import { BigInt } from '@graphprotocol/graph-ts';

export function handleAuctionExtended(event: AuctionExtended): void {}

export function handleBidIncreased(event: BidIncreased): void {}

export function handleNewBid(event: NewBid): void {
  let entity = new AuctionBid(event.transaction.hash);
  entity.user = event.params.bidder;
  entity.amount = event.params.value;
  entity.timestamp = event.block.timestamp;
  entity.save();
}

export function handleOwnershipTransferred(event: OwnershipTransferred): void {}
