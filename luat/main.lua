PROJECT = "SOCKET_LONG_CONNECTION_TRANSPARENT"
VERSION = "1.0.0"
require"sys"
require"wdt"
require"config"
require"nvm"
require"mcuart"
require"misc"

--初始化参数管理模块
nvm.init("config.lua")

require"LEWEI50"
require"sck"

sys.init(0,0)
sys.run()
