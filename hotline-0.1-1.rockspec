package = 'hotline'
version = '0.1-1'
source = {
    url = 'git+https://github.com/gokselgoktas/hotline.git'
}
description = {
    summary = 'A simple and straightforward utility library for Lua',
    homepage = 'https://github.com/gokselgoktas/hotline',
    license = 'WTFPL'
}
dependencies = {
    'lua >= 5.3'
}
build = {
    type = 'builtin',
    modules = {
        hotline = 'hotline.lua'
    }
}
