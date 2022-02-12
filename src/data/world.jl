const WorldCache = Dict{Tuple{Int, Int}, Int}
const MAXWORLDTYPE = 3

"""
Looks for a tile and generates it if not existing.
"""
function getTile(x::Int, y::Int, db=getDB()) 
    data = DBInterface.execute(db, """
        SELECT * FROM worldmap WHERE x = $x AND y = $y
    """) |> DataFrame
    try
        return data.type[1]
    catch
        @debug "Tile doesn't exist, generating."
        r = rand(0:MAXWORLDTYPE)
        DBInterface.execute(db, """
        INSERT INTO worldmap (x, y, type)
        VALUES ($x, $y, $r)
        """)
        return getTile(x, y)
    end 
end
"""
Caches the tile.
There is no force option, as tiles don't change.
"""
function getTile(x::Int, y::Int, cache::WorldCache) 
    if (x, y) in cache 
        cache[(x, y)]
    else 
        v = getTile(x, y)
        cache[(x, y)] = v
        v
    end
end
getTile(pos::Position, args...) = getTile(pos.x, pos.y, args...)