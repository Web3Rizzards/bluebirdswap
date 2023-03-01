import { Transfer } from "../../generated/BBYC/ERC721";
import { createErc721Collection } from "../helpers";
import { handleTransfer721 } from "../mapping";

export function handleTransfer(event: Transfer): void {
  createErc721Collection(event.address, "BBYC");

  handleTransfer721(event);
}
