module challenge::hero;

use std::string::String;

// ========= STRUCTS =========
public struct Hero has key, store {
    id: UID,
    name: String,
    image_url: String,
    power: u64,
}

public struct HeroMetadata has key, store {
    id: UID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

#[allow(lint(self_transfer))]
public fun create_hero(name: String, image_url: String, power: u64, ctx: &mut TxContext) {

    let id = sui::object::new(ctx);
    let hero = Hero {id, name, image_url, power};
    let sender = tx_context::sender(ctx);
    sui::transfer::public_transfer(hero, sender);
    let timestamp = ctx.epoch_timestamp_ms();
    let meta_id = sui::object::new(ctx);
    let heroMetadata = HeroMetadata {id: meta_id, timestamp};
    sui::transfer::freeze_object(heroMetadata);

    // TODO: Create a new Hero struct with the given parameters
        // Hints:
        // Use object::new(ctx) to create a unique ID
        // Set name, image_url, and power fields
    // TODO: Transfer the hero to the transaction sender
    // TODO: Create HeroMetadata and freeze it for tracking
        // Hints:
        // Use ctx.epoch_timestamp_ms() for timestamp
    //TODO: Use transfer::freeze_object() to make metadata immutable
}

// ========= GETTER FUNCTIONS =========

public fun hero_power(hero: &Hero): u64 {
    hero.power
}

#[test_only]
public fun hero_name(hero: &Hero): String {
    hero.name
}

#[test_only]
public fun hero_image_url(hero: &Hero): String {
    hero.image_url
}

#[test_only]
public fun hero_id(hero: &Hero): ID {
    object::id(hero)
}

