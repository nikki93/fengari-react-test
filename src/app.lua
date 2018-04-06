require './base.css'

local React = require 'react'

-- Convert a Lua value `val` to a JavaScript value
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

-- A table of 'tags' for React component types
local R = setmetatable({}, {
    __index = function(r, elementType)
        local tag = function(t)
            if type(t) ~= 'table' then
                return React:createElement(elementType, js.null, t)
            end
            return React:createElement(elementType, JS(t), table.unpack(t))
        end
        r[elementType] = tag -- Cache it
        return tag
    end
})

local logo = require './logo.svg'

local App = function()
    setmetatable(_ENV, { __index = R })
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
        img {
            src = logo,
            alt = 'logo'
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
        p {
            'To get started, edit ', code 'src/test.lua', ' and save to reload.',
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

ReactDOM:render(R[App] {}, js.global.document:getElementById('root'))
