function getUserData(id::AbstractString, db=getDB())
    data = DBInterface.execute(db, """
        SELECT * FROM userdata WHERE id = '$id'
    """) |> DataFrame
    if length(data[!, 1]) == 0
        return (false, missing)
    else
        return (true, getUserData(data))
    end
end
function getUserData(data::DataFrame)
    pos = Position(
      data.x[1],
      data.y[1]
    )
    inv = JSON3.read(data.inv[1], Vector{InventoryItem})
    Player(
        pos,
        data.char[1],
        data.emp[1],
        inv,
        data.rank[1],
        data.id[1]
    ) 
end
function getUserData(id::String, cache::PlayerCache, force=false)
    if id in keys(cache) && !force
        cache[id]
    else 
        ply = getUserData(id)
        cache[ply.id] = ply
        ply
    end
end

function saveUserData(ply::Player, db=getDB())
    DBInterface.execute(db, """
    UPDATE userdata 
    SET x = $(ply.pos.x), y = $(ply.pos.y), char = $(ply.char), emp = $(ply.emp), inv = '$(JSON3.write(ply.inv))', rank = $(ply.rank)
    WHERE id = '$(ply.id)'
    """)
end
saveUserData(id::AbstractString, cache::PlayerCache, db=getDB()) = saveUserData(getUserData(id, cache), db)

function createUser(id::String, char::Int)
    pos = Position(
        rand(200:500),
        rand(300:400)
    )
    ply = Player(
        pos,
        char,
        0,
        [],
        0,
        id
    )  
    createUser(ply)
    ply
end
function createUser(ply::Player, db=getDB())
    DBInterface.execute(db, """
    INSERT INTO userdata (x, y, char, emp, inv, rank, id)
    VALUES ($(ply.pos.x), $(ply.pos.y), $(ply.char), $(ply.emp), '$(JSON3.write(ply.inv))', $(ply.rank), '$(ply.id)')
    """)
end