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
    return R.div {
        R.p {
            style = { textAlign = 'right' },
            R.a { href = '/', 'home' },
        },
        R.h2 'Welcome to React',
        R.div {
            className = 'date',
            '2018-04-05',
        },
        R.img {
            src = logo,
            alt = 'logo'
        },
        R.div {
            style = {
                display = 'flex',
                justifyContent = 'center',
            },
            R.button {
                style = { textAlign = 'center' },
                onClick = function()
                    js.global:alert('clicked!')
                end,
                'Click me! :)',
            },
        },
        R.p {
            'To get started, edit ', R.code 'src/test.lua', ' and save to reload.',
        },
        R.div {
            className = 'content-footer',
            R.ul {
                R.li 'one',
                R.li 'two',
            },
        },
        R.ol {
            className = 'footnotes',
            R.li 'omg',
            R.li 'kk',
        }
    }
end


local ReactDOM = require 'react-dom'

ReactDOM:render(R[App] {}, js.global.document:getElementById('root'))
