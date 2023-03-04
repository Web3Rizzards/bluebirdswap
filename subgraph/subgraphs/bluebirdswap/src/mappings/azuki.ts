import { createErc721Collection, handleTransfer721 } from "../helpers";

import { Transfer } from "../../generated/BBYC/ERC721";

export function handleTransfer(event: Transfer): void {
  createErc721Collection(event.address, "Azuki");

  handleTransfer721(event);
}
