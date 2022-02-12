module Elvur

using StructTypes
using JSON3
using SQLite
using DataFrames
using Logging

io = open("log.txt", "w+")
logger = SimpleLogger(io)
global_logger(logger)

include("types/types.jl")

allitems() = AllItems(JSON3.read(read("D:\\Code\\.julia\\dev\\Elvur\\data\\items.json", String), Vector{Item}))

include("data/data.jl")
include("main.jl")

end
