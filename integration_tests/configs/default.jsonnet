{
  'cronos_777-1': {  // chain id should start with 'cronos'
    'start-flags': '--trace',
    cmd: 'cronosd',  // make sure the path to the directory containing the `cronosd` executable is in the `PATH` variable

    local _1mil_tcro = '1000000000000000000000000basetcro',  // (10^6) * (10^18)
    local _10quintillion_stake = '10000000000000000000stake',  // 10 * (10^18)
    local _1quintillion_stake = '1000000000000000000stake',  // (10^18)
    local _1mil_qatest = '1000000qatest',
    local _big = '1000000000000000000000000000000000000000000000000000000big',  // (10^54)

    validators: [
      {
        coins: std.join(',', [_1mil_tcro, _1quintillion_stake]),
        staked: _1quintillion_stake,
        mnemonic: 'elbow flight coast travel move behind sister tell avocado road wait above',
        gas_prices: '10000000000000basetcro',
        base_port: 26650,
      },
      {
        coins: std.join(',', [_1mil_tcro, _1quintillion_stake]),
        staked: _1quintillion_stake,
        mnemonic: 'nasty large defy garage violin casual alarm blue marble industry infant inside',
        gas_prices: '10000000000000basetcro',
        base_port: 26660,
      },
      {
        coins: std.join(',', [_1mil_tcro, _1quintillion_stake]),
        staked: _1quintillion_stake,
        mnemonic: 'lobster culture confirm twist oak sock lucky core kiss echo term faint robot purity fluid mix rescue music drive spot term pistol feed abuse',
        gas_prices: '10000000000000basetcro',
        base_port: 26670,
      },
      {
        coins: std.join(',', [_1mil_tcro, _1quintillion_stake]),
        staked: _1quintillion_stake,
        mnemonic: 'wonder grocery sing soccer two portion shift science gain tuition mean garbage feed execute brush civil buddy filter mandate aunt rocket quarter aim first',
        gas_prices: '10000000000000basetcro',
        base_port: 26680,
      },
      {
        moniker: 'fullnode',
        gas_prices: '10000000000000basetcro',
        base_port: 26550,
      },
    ],
    accounts: [
      {
        name: 'rich',
        coins: std.join(',', [_1mil_tcro, _1mil_qatest, _10quintillion_stake, _big]),
        mnemonic: 'super develop desert oak load field ring jazz tray spray found novel',
      },
      {
        name: 'alice',
        coins: std.join(',', [_1mil_tcro, _1mil_qatest, '50stake', _big]),
        mnemonic: 'loyal legend allow glow wheel heavy pretty example tell peasant myself garlic battle bachelor buddy stand true grit manual letter wire alone polar glove',
      },
      {
        name: 'bob',
        coins: std.join(',', [_1mil_tcro, _1mil_qatest]),
        mnemonic: 'style recipe economy valve curtain raw scare unable chair silly impact thrive moment copy able voyage slush diary adjust boss smile finger volume reward',
      },
      {
        name: 'charlie',
        coins: std.join(',', [_1mil_tcro, _1mil_qatest]),
        mnemonic: 'frost worth crisp gasp this waste harbor able ethics raise december tent kid brief banner frame absent fragile police garage remind stomach side midnight',
      },
      {
        name: 'dave',
        coins: std.join(',', [_1mil_tcro, _1mil_qatest]),
        mnemonic: 'worth lounge teach critic forward disease shy genuine rain gorilla end depth sort clutch museum festival stay joke custom anchor seven outside equip crawl',
      },
      {
        name: 'mallory',
        coins: _1mil_tcro,
        mnemonic: 'spare base company veteran anxiety lyrics echo caught wash guard world guilt tone various shift uphold remain jealous young object gospel cluster focus lamp',
      },
      {
        name: 'cronos_admin',
        coins: _1mil_tcro,
        mnemonic: 'fetch device over giraffe fit code leave bamboo wash check ten course wedding process sudden fish pause tag rose settle thought harvest select boil',
      },
      {
        name: 'relayer',
        coins: _1mil_tcro,
        mnemonic: 'summer account another open charge item reason double green winner six genuine glue daughter index pause bulb rival adult boss enlist bench oxygen asthma',
      },
      {
        name: 'circuit_admin',
        coins: std.join(',', [_1mil_tcro, _1mil_qatest]),
        mnemonic: 'accuse whisper poverty benefit lobster mango evidence toy believe wave bachelor damp glimpse sword matter spice race acquire own grape equip liberty never shiver',
      },
    ],

    // NOTE: configs below without a comment is same as the testnet

    config: {  // patch to config.toml
      'unsafe-ignore-block-list-failure': true,  // start validator even if block list can't be decrypted
      consensus: {
        timeout_commit: '5s',
        create_empty_blocks_interval: '5s',
      },
    },

    'app-config': {  // patch to app.toml
      'minimum-gas-prices': '5000000000000basetcro',
      // `app-db-backend` to config db types for `/data/application.db`
      'app-db-backend': 'goleveldb',
      pruning: 'nothing',
      staking: {
        'cache-size': 10,  // -1 = disabled, 0 = unlimited, >0 = size limit
      },
      rosetta: {
        'denom-to-suggest': 'basetcro',
      },
      evm: {
        'max-tx-gas-wanted': 0,
        'optimistic-execution': 'disable',
      },
      'json-rpc': {
        address: '0.0.0.0:{EVMRPC_PORT}',
        'ws-address': '0.0.0.0:{EVMRPC_PORT_WS}',
        api: 'eth,net,web3,debug,cronos',
        'block-range-cap': 30,
        'evm-timeout': '10s',
      },
      'blocked-addresses': [],
      mempool: {
        'max-txs': 0,  //allow for a unbounded amount of transactions in the mempool.
      },
    },
    genesis: {  // patch to genesis.json
      consensus: {
        params: {
          block: {
            max_bytes: '1048576',
            max_gas: '81500000',
          },
          evidence: {
            max_age_num_blocks: '403200',
            max_age_duration: '2419200000000000',
            max_bytes: '150000',
          },
        },
      },
      app_state: {
        bank: {
          send_enabled: [
            {
              denom: 'stake',
              enabled: true,
            },
            {
              denom: 'basetcro',
              enabled: false,
            },
          ],
        },
        cronos: {
          params: {            
            cronos_admin: 'crc12luku6uxehhak02py4rcz65zu0swh7wjsrw0pp',
            // ibc_denom := 'ibc/' + SHA256('transfer/channel-0/basetcro')
            ibc_cro_denom: 'ibc/6B5A664BF0AF4F71B2F0BAA33141E2F1321242FBD5D19762F541EC971ACB0865',
          },
        },
        distribution: {
          params: {
            community_tax: '0',
            base_proposer_reward: '0',
            bonus_proposer_reward: '0',
          },
        },
        evm: {
          params: {
            evm_denom: 'basetcro',
            // no extra_eips for devnet, as london hardfork is not finalized at the testnet genesis
          },
        },
        gov: {
          // smaller deposit and voting period, smaller deposit amount, to speed up the governance process
          params: {
            min_deposit: [
              {
                denom: 'basetcro',
                amount: '5',
              },
            ],
            max_deposit_period: '30s',
            voting_period: '30s',
            expedited_voting_period: '15s',
            expedited_min_deposit: [
              {
                denom: 'basetcro',
                amount: '25',
              },
            ],
          },
        },
        ibc: {
          client_genesis: {
            params: {
              allowed_clients: [
                '06-solomachine',
                '07-tendermint',
                '09-localhost',
              ],
            },
          },
        },
        icaauth: {
          // smaller minimum timeout duration, to set smaller timeout-duration flag for `tx icaauth submit-tx` command
          params: {
            min_timeout_duration: '1ms',
          },
        },
        mint: {
          minter: {
            inflation: '0.000000000000000000',
            annual_provisions: '0.000000000000000000',
          },
          params: {
            inflation_rate_change: '0',
            inflation_max: '0',
            inflation_min: '0',
            goal_bonded: '1',
          },
        },
        slashing: {
          params: {
            downtime_jail_duration: '60s',
            min_signed_per_window: '0.5',
            signed_blocks_window: '10',
            slash_fraction_double_sign: '0',
            slash_fraction_downtime: '0',
          },
        },
        staking: {
          params: {
            // smaller unbonding time, to speed up the unbonding process
            unbonding_time: '120s',
            max_validators: '50',
          },
        },
        feemarket: {
          // from https://rest-t3.cronos.org/ethermint/feemarket/v1/params
          params: {
            no_base_fee: false,
            base_fee_change_denominator: 100,
            elasticity_multiplier: 4,
            // enabled at genesis, different from testnet
            enable_height: '0',
            // initial base fee at genesis, testnet shows the current base fee, hence different
            base_fee: '375000000000',
            min_gas_price: '375000000000',
            min_gas_multiplier: '0.500000000000000000',
          },
        },
      },
    },
  },
}
