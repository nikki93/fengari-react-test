require './base.css'

local React = require 'react'

-- Convert a Lua value `val` to a JavaScript value. Lua tables are converted to JavaScript objects
-- filtered to stringly-typed keys, with values recursively converted. Other Lua values are passed
-- through with Fengari semantics.
local function JS(val)
    if type(val) == 'table' then
        local o = js.new(js.global.Object)
        for k, v in pairs(val) do
            if type(k) == 'string' then
                o[k] = JS(v)
            end
        end
        return o
    end
    return val
end

-- Create a 'tag' given the `type` parameter for `React.createElement(type, ...)`. See
-- https://reactjs.org/docs/react-api.html#createelement The tag is a single-argument function
-- rapping `React.createElement(...)`. If the single argument is not a table, it is passed as a
-- child of the element. If the single argument is a table, all string-keyed elements are passed as
-- props, and the sequence part of the table is passed as children. This enables the following
-- syntax:
--
--   local tag = createTag(<type>)
--
--   tag <child1>
--
--   tag {
--     <prop1> = <value1>,
--     <prop2> = <value2>,
--     <child1>,
--     <child2>,
--   }
--
local function createTag(elementType)
    return function(conf)
        if type(conf) ~= 'table' then
            return React:createElement(elementType, js.null, conf)
        end
        return React:createElement(elementType, JS(conf), table.unpack(conf))
    end
end

-- A table of 'tags' for DOM components where `dom[<type>]` gives the tag for DOM element type
-- `<type>`. Example use:
--
--   div {
--     p {
--         style = { textAlign = 'right' },
--         a { href = '/', 'home' },
--     },
--     h2 'Welcome to React',
--     div {
--         className = 'date',
--         '2018-04-05',
--     },
--   }
--
local dom = setmetatable({}, {
    __index = function(r, type)
        local tag = createTag(type)
        r[type] = tag -- Cache it
        return tag
    end
})


local createClass = require 'create-react-class'

local TestStateful = createTag(createClass(JS {
    getInitialState = function(self)
        return {
            count = 0,
        }
    end,

    render = function(self)
        return p {
            style = { textAlign = 'right' },
            self.count,
        }
    end,
}))

local TestStateless = createTag(function(self, props)
    return p {
        style = { textAlign = 'right' },
        props.children,
    }
end)


local App = function()
    setmetatable(_ENV, { __index = dom })
    return div {
        p {
            style = { textAlign = 'right' },
            a { href = '/', 'home' },
        },
        h2 'Welcome to React',
        div {
            className = 'date',
            '2018-04-05',
        },
        p {
            'To get started, edit ', code 'src/test.lua', ' and save to reload.',
        },
        TestStateless { 'woah ', 'dude' },
        blockquote {
            'To get started, edit and save to reload.',
        },
        p {
            [[
Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium,
totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae
dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit,
sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam
est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius
modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima
veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea
commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil
molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
            ]],
        },
        pre {
            [[
scope.create().send(function()
    name = 'Circle'

    x, y = 0, 0
    r, g, b = 1, 1, 1
    radius = 5
    fill = true

    function draw()
        love.graphics.push('all')
        love.graphics.setColor(r, g, b)
        love.graphics.ellipse(fill and 'fill' or 'line',
            x, y, radius, radius)
        love.graphics.pop()
    end

    inherit(Subscribe)
end)

local N = 200
for i = 1, N do
    scope.create().send(function()
        inherit(Circle)

        y = 100 + i * 500 / N
        r = i / N
        time = 60

        function tick(dt)
            cont(dt)
            time = time + dt
            x = i * 2 * math.sin(0.002 * i * time)
        end

        subscribe(Clock, Screen)
    end)
end
            ]]
        },
        div {
            style = {
                display = 'flex',
                justifyContent = 'center',
            },
            button {
                style = { textAlign = 'center' },
                onClick = function()
                    js.global:alert('clicked!')
                end,
                'Click me! :)',
            },
        },
        img {
            src = require './logo.svg',
            alt = 'logo'
        },
        div {
            className = 'content-footer',
            ul {
                li 'one',
                li 'two',
            },
        },
        ol {
            className = 'footnotes',
            li 'omg',
            li 'kk',
        }
    }
end


local ReactDOM = require 'react-dom'

ReactDOM:render(createTag(App) {}, js.global.document:getElementById('root'))
