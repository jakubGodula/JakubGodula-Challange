module challenge::arena;

use challenge::hero::Hero;
use sui::event;
use sui::transfer::{public_transfer, share_object};


// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: ID,
    loser_hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {

    let id = object::new(ctx);
    let owner = ctx.sender();
    let arena = Arena {id, warrior: hero, owner};
    event::emit(ArenaCreated {
        arena_id: object::id(&arena),
        timestamp: ctx.epoch_timestamp_ms()
    });
    share_object(arena);



    // TODO: Create an arena object
        // Hints:
        // Use object::new(ctx) for unique ID
        // Set warrior field to the hero parameter
        // Set owner to ctx.sender()
    // TODO: Emit ArenaCreated event with arena ID and timestamp (Don't forget to use ctx.epoch_timestamp_ms(), object::id(&arena))
    // TODO: Use transfer::share_object() to make it publicly tradeable
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    let Arena {id, warrior, owner} = arena;
    
    let hero_id = object::id(&hero);
    let warrior_id = object::id(&warrior);
    
    if (hero.hero_power() > warrior.hero_power()) {
        // Hero wins - both heroes go to ctx.sender()
        event::emit(ArenaCompleted {
            winner_hero_id: hero_id,
            loser_hero_id: warrior_id,
            timestamp: ctx.epoch_timestamp_ms(),
        });
        public_transfer(hero, ctx.sender());
        public_transfer(warrior, ctx.sender());
    } else {
        // Warrior wins - both heroes go to arena owner
        event::emit(ArenaCompleted {
            winner_hero_id: warrior_id,
            loser_hero_id: hero_id,
            timestamp: ctx.epoch_timestamp_ms(),
        });
        public_transfer(hero, owner);
        public_transfer(warrior, owner);
    };
    
    object::delete(id); 
}

