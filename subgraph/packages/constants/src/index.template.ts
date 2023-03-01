import { Address, BigInt } from '@graphprotocol/graph-ts';

// Global
export const BURNER_ADDRESS = Address.fromString('{{ burner_address}}');
export const EXPLORER = '{{ explorer }}';
export const MAGIC_ADDRESS = Address.fromString(
  '{{magic_address}}{{^magic_address}}{{burner_address}}{{/magic_address}}'
);

// bluebird
export const bluebird_ADDRESS = Address.fromString(
  '{{bluebird_address}}{{^bluebird_address}}{{burner_address}}{{/bluebird_address}}'
);
export const ARGONAUTS_ADDRESS = Address.fromString(
  '{{argonauts_address}}{{^argonauts_address}}{{burner_address}}{{/argonauts_address}}'
);
export const bluebird_PLANETS_ADDRESS = Address.fromString(
  '{{bluebird_planets_address}}{{^bluebird_planets_address}}{{burner_address}}{{/bluebird_planets_address}}'
);
export const bluebird_MATERIALS_ADDRESS = Address.fromString(
  '{{bluebird_materials_address}}{{^bluebird_materials_address}}{{burner_address}}{{/bluebird_materials_address}}'
);
export const bluebird_COMPONENTS_ADDRESS = Address.fromString(
  '{{bluebird_components_address}}{{^bluebird_components_address}}{{burner_address}}{{/bluebird_components_address}}'
);
export const bluebird_SPACESHIPS_ADDRESS = Address.fromString(
  '{{bluebird_spaceships_address}}{{^bluebird_spaceships_address}}{{burner_address}}{{/bluebird_spaceships_address}}'
);
export const bluebird_MARKETPLACE_ADDRESS = Address.fromString(
  '{{bluebird_marketplace_address}}{{^bluebird_marketplace_address}}{{burner_address}}{{/bluebird_marketplace_address}}'
);

// Start Blocks

export const bluebird_MARKETPLACE_START_BLOCK = BigInt.fromString(
  '{{bluebird_marketplace_start_block}}{{^bluebird_marketplace_start_block}}0{{/bluebird_marketplace_start_block}}'
);

export const USDC = '{{usdc_address}}{{^usdc_address}}{{burner_address}}{{/usdc_address}}';

export const USDT = '{{usdt_address}}{{^usdt_address}}{{burner_address}}{{/usdt_address}}';

export const DAI = '{{dai_address}}{{^dai_address}}{{burner_address}}{{/dai_address}}';

export const NATIVE = MAGIC_ADDRESS;

export const USDC_WETH_PAIR =
  '{{usdc_weth_pair_address}}{{^usdc_weth_pair_address}}{{burner_address}}{{/usdc_weth_pair_address}}';

export const DAI_WETH_PAIR = '{{dai_weth_pair}}{{^dai_weth_pair}}{{burner_address}}{{/dai_weth_pair}}';

export const USDT_WETH_PAIR = '{{usdt_weth_pair}}{{^usdt_weth_pair}}{{burner_address}}{{/usdt_weth_pair}}';
