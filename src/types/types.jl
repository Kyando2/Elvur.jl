field(k::QuoteNode, ::Type{T}) where T = :($T(kwargs[$k]))
field(k::QuoteNode, ::Type{Vector{T}}) where T = :($T.(kwargs[$k]))

function symbolize(dict::Dict{String, Any}) 
    new = Dict{Symbol, Any}()
    for (k, v) in dict
        new[Symbol(k)] = symbolize(v)
    end
    new
end
symbolize(t::Any) = t 

macro constructors(T)
    TT = eval(T)
    args = map(f -> field(QuoteNode(f), fieldtype(TT, f)), fieldnames(TT))
    quote
        function $(esc(T))(; kwargs...) 
            $(esc(T))($(args...))
        end
        $(esc(T))(d::Dict{Symbol, Any}) = $(esc(T))(; d...)
        $(esc(T))(d::Dict{String, Any}) = $(esc(T))(; symbolize(d)...)
        $(esc(T))(d::$(esc(T))) = d
        function StructTypes.keyvaluepairs(x::$(esc(T))) 
            d = Dict{Symbol, Any}()
            for k = fieldnames(typeof(x))
                d[k] = getfield(x, k)
            end
            d
        end
        StructTypes.StructType(::Type{$(esc(T))}) = StructTypes.DictType()
    end
end

include("items.jl")
include("player.jl")

@constructors Recipe
@constructors Item
@constructors Effect
@constructors InventoryItem