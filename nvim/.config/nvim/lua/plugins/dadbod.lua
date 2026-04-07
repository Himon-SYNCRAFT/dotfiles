-- lua/plugins/dadbod.lua
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_table_helpers = {
    postgresql = {
        Count = 'SELECT count(*) FROM "{table}"',
        Where  = 'SELECT count(*) FROM "{table}" WHERE',
    },
    sqlite = {
        Count = 'SELECT count(*) FROM "{table}"',
        Where  = 'SELECT count(*) FROM "{table}" WHERE',
    },
    mysql = {
        Count = 'SELECT count(*) FROM "{table}"',
        Where  = 'SELECT count(*) FROM "{table}" WHERE',
    },
}
