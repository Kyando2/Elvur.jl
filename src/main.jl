using Ekztazy

### +----------------------
### | This is basically just a remake of 
### | https://github.com/Kyando2/AniBot/blob/master/cogs/Money.py.
### | The commands are just being 1:1 copied with a few additions
### | that I wanted to do anyway.
### | An non exhaustive list of big differences:
### | ーMoney doesn't exist, it's just calculated based on the posessed items.
### | ーーPaying/Buying doesn't exist. You can trade with items.
### | ーーsome items are more suited to an economy.
### | ーComponents/Slash Commands instead of *disgusting* plain old commands.
### | ーRemove the absolutely unnecessary OOP (like ItemHandler and PlayerHandler).
### | ーFix a lot of really just bad code in there (I was like 12 when I wrote it spare me).
### | ーAdd some new features.
### | ーーCharacter, you now get to choose a character which gives you some bonuses.
### | ーーWorld map, I had started that over in the other project, but now its a full fledged map system.
### | ーーEmpires! You get to fight for a country, or even maybe create one!
### | ーーPVP!!!
### | ーーPVE!!!
### | ーThis is made in Julia, not Python. Python is disgusting.
### +-- 
### | The text here definitely needs some help.
### +--
### | Maybe perform registration check for all commands.
### +--
### | Maybe handlers should be moved to a sub folder, 
### | so each series of command->component has its own folder.
### +--
### | Maybe make a function in separate modules for each handler series.
### +--
### | The getClient() function is just to prevent having to do global
### | on each handler, instead you can just have a default argument
### | which shouldn't mess with Ekztazy, unless you try to do this 
### | with the new mode of handlers (which would then mess with Ekztazy in 0.7, 
### | see https://github.com/Humans-of-Julia/Ekztazy.jl/issues/54).
### +--
### | getId() should probably be implemented by Ekztazy
### | (but like better, like actually check if its in a guild or in DMs),
### | IDK who made Ekztazy but like why do they not have that?? 
### +--
### | This uses Ekztazy >0.5, and probably doesn't work with 0.4 but IDK tbh.
### +----------------------


function getClient() 
    global c
    c
end

getId(ctx::Context) = string(ctx.interaction.member.user.id)

function init() 
    global c

    g = ENV["TESTGUILD"]

    command!(register_command_handler, c, g, "register", "Register as a new player")

    on_ready!(c) do ctx
        @info "Successfully logged in!"
    end

    start(c)
end

function register_command_handler(ctx, c=getClient())
    global REG_DEF_COMP
    id = getId(ctx)
    t = getUserData(id)
    if t[1] == false 
        reply(c, ctx, components=[REG_DEF_COMP], content="Hey, welcome to the world of Elvur!", flags=1<<6)
    else 
        reply(c, ctx, content="You are already registered!")
    end
end

function register_component_first_default(ctx, c=getClient())
    global REG_KEN_COMP2
    reply(c, ctx, components=[REG_KEN_COMP2], content="Welcome to the world of Elvur... What character you want?", flags=1<<6)
end

function register_component_second_ken(ctx, c=getClient())
    id = getId(ctx)
    # ken is id 0, make const later
    createUser(id, 0)
    reply(c, ctx, content="So you've chosen **Ken Kaneki**. You can now start playing.", flags=1<<6)
end

c = Client()
REG_DEF_COMP = component!(register_component_first_default, c, "default00"; type=2, style=1, label="Start!")
REG_KEN_COMP2 = component!(register_component_second_ken, c, "ken00"; type=2, style=1, label="Ken Kaneki")

