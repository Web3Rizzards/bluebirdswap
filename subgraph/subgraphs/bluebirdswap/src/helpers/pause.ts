import { bluebird_MARKETPLACE_ADDRESS, bluebird_MARKETPLACE_START_BLOCK } from '@bluebird/constants';

import { ethereum } from '@graphprotocol/graph-ts';

export function isPaused(event: ethereum.Event): boolean {
  return event.block.number.gt(bluebird_MARKETPLACE_START_BLOCK) && event.address.equals(bluebird_MARKETPLACE_ADDRESS);
}
