struct Effect
    type::Int # What effect 
    value::Int # How strong the effect is
end

struct Recipe
    required::Vector{Int}
    quantity::Vector{Int}
end

struct Item 
    name::String
    id::Int
    edible::Bool
    fishing::Int
    exploit::Int
    effects::Vector{Effect}
    recipes::Vector{Recipe}
end

struct AllItems
    v::Vector{Item}
end