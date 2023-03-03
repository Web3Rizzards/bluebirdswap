import { AnswerUpdated } from "./../../generated/AzukiPriceFeed/AzukiPriceFeed";
import { BigInt } from "@graphprotocol/graph-ts";
import { PriceData } from "../../generated/schema";

/**
 * Event is fired when user new price is updated
 * This event will update a user's balance of option contracts
 * @param event
 */

export function handleAnswerUpdated(event: AnswerUpdated): void {
  // Create new price instance
  let price = new PriceData(event.transaction.hash.toHex());
  price.roundId = event.params.roundId;
  price.answer = event.params.current;
  price.timestamp = event.params.updatedAt;
  price.save();
}
