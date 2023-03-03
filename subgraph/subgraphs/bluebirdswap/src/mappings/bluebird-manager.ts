import {
  CallOptionCreated,
  Claimed,
  PutOptionCreated,
} from "../../generated/BluebirdManager/BluebirdManager";
import { Option, Trade } from "../../generated/schema";

import { BigInt } from "@graphprotocol/graph-ts";
import { Bought } from "./../../generated/BluebirdManager/BluebirdManager";

/**
 * Event is fired when user purchases option contracts
 * This event will update a user's balance of option contracts
 * @param event
 */

export function handleBought(event: Bought): void {
  let tradeId =
    event.params._user.toHexString() +
    "-" +
    event.params._contractAddress.toString() +
    "-" +
    event.params._optionId.toString();

  let trade = Trade.load(tradeId);

  let optionId =
    event.params._contractAddress.toHexString() +
    "-" +
    event.params._optionId.toString();

  if (!trade) {
    trade = new Trade(event.transaction.hash.toHex());
    trade.option = optionId;
    trade.premium = event.params._premium;
    trade.size = event.params._amount;
    trade.owner = event.params._user;
    trade.exercised = false;
    trade.isProfit = false;
    trade.pl = BigInt.fromI32(0);
    trade.timestamp = event.block.timestamp;
    trade.save();
  } else {
    trade.premium = trade.premium.plus(event.params._premium);
    trade.size = trade.size.plus(event.params._amount);
    trade.save();
  }
}

export function handleCallOptionCreated(event: CallOptionCreated): void {
  let optionId =
    event.params._contractAddress.toHexString() +
    "-" +
    event.params._optionId.toString();

  let option = Option.load(optionId);

  if (!option) {
    option = new Option(optionId);
    option.token = event.params._nftToken.toHexString();
    option.epoch = event.params._epoch;
    option.strikePrice = event.params._strikePrice;
    option.isPut = false;
    option.startTime = event.params._start;
    option.expiry = event.params._expiry;
    option.save();
  }
}

export function handlePutOptionCreated(event: PutOptionCreated): void {
  let optionId =
    event.params._contractAddress.toHexString() +
    "-" +
    event.params._optionId.toString();

  let option = Option.load(optionId);

  if (!option) {
    option = new Option(optionId);
    option.token = event.params._nftToken.toHexString();
    option.epoch = event.params._epoch;
    option.strikePrice = event.params._strikePrice;
    option.isPut = true;
    option.startTime = event.params._start;
    option.expiry = event.params._expiry;
    option.save();
  }
}

/**
 * Event is fired when user claims the rewards (if any) of a trade
 * @param event
 */
export function handleClaimed(event: Claimed): void {
  let tradeId =
    event.params._user.toHexString() +
    "-" +
    event.params._contractAddress.toString() +
    "-" +
    event.params._order.toString();
  let trade = Trade.load(tradeId);

  if (trade) {
    trade.exercised = true;
    trade.isProfit = trade.premium.lt(event.params._profits);
    trade.pl = trade.isProfit
      ? event.params._profits.minus(trade.premium)
      : trade.premium.minus(event.params._profits);
    trade.save();
  }
}
