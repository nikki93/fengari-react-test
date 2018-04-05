require './App.css'

local React = require 'react'

local R = setmetatable({}, {
    __index = function(r, elementType)
        local tag = function(t)
            local props = js.new(js.global.Object)
            for k, v in pairs(t) do
                if type(k) == 'string' then
                    props[k] = v
                end
            end
            return React:createElement(elementType, props, table.unpack(t))
        end
        r[elementType] = tag -- Cache it
        return tag
    end
})

local logo = require './logo.svg'

local App = function()
    return R.div {
        className = 'App',
        R.header {
            className = 'App-header',
            R.img {
                src = logo,
                className = 'App-logo',
                alt = 'logo'
            },
            R.h1 {
                className = 'App-title',
                'Welcome to React',
            },
        },
        R.p {
            className = 'App-intro',
            'To get started, edit ', R.code { 'src/test.lua' }, ' and save to reload.',
        },
    }
end


local ReactDOM = require 'react-dom'

require './index.css'

ReactDOM:render(R[App] {}, js.global.document:getElementById('root'))
