ENERGY_DATA = Dict{String, Int}()
const MAXENERGY = 20

function energy(id::String) 
    global ENERGY_DATA, MAXENERGY
    if id in ENERGY_DATA
        ENERGY_DATA[id]
    else
        ENERGY_DATA[id] = MAXENERGY
        energy(id)
    end
end
energy(ply::Player) = energy(ply.id)

function init_cache()
    return (PlayerCache(), WorldCache())
end

"""
Returns the DB at the default location.
"""
getDB() = SQLite.DB("D:\\Code\\.julia\\dev\\Elvur\\data\\wrld.db")

include("player.jl")
include("world.jl")