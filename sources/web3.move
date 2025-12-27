module wallet_address::StrategyGame {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a player's game account
    struct PlayerAccount has store, key {
        hero_nft_id: u64,      // Unique ID of the hero NFT owned
        resources: u64,         // In-game resources collected
        battles_won: u64,       // Total battles won by player
    }

    /// Function to initialize a new player with a hero NFT
    public fun create_player(player: &signer, hero_id: u64) {
        let account = PlayerAccount {
            hero_nft_id: hero_id,
            resources: 100,  // Starting resources
            battles_won: 0,
        };
        move_to(player, account);
    }

    /// Function to complete a battle and earn rewards
    public fun complete_battle(
        player: &signer, 
        player_addr: address, 
        reward_amount: u64
    ) acquires PlayerAccount {
        let account = borrow_global_mut<PlayerAccount>(player_addr);
        
        // Increment battle wins
        account.battles_won = account.battles_won + 1;
        
        // Add resources as reward
        account.resources = account.resources + reward_amount;
        
        // Transfer token rewards to player
        let reward = coin::withdraw<AptosCoin>(player, reward_amount);
        coin::deposit<AptosCoin>(player_addr, reward);
    }
}