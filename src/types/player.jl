mutable struct Position 
    x::Int
    y::Int
end

struct InventoryItem
    id::Int
    quantity::Int
end

mutable struct Player 
    pos::Position
    char::Int
    emp::Int
    inv::Vector{InventoryItem}
    rank::Int
    id::String
end

const PlayerCache = Dict{String, Player}

