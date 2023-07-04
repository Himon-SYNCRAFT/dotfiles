require('orgmode').setup_ts_grammar()

require('orgmode').setup({
    org_agenda_files = {
        '~/Remote/syncraft@google/org/**/*', '~/Documents/org/**/*'
    },
    org_default_notes_file = '~/Remote/syncraft@google/org/notes.org',
    org_todo_keywords = {
        'TODO(t)', 'PROCESSING(p)', 'WAIT(w)', '|', 'DONE(d)', 'CANCELLED(c)'
    },
    -- win_split_mode = 'vsplit',
    org_hide_leading_stars = true,
    org_use_tag_inheritance = false,
    mappings = {
        agenda = {org_agenda_goto = '<CR>', org_agenda_switch_to = '<TAB>'}
    }
})

-- require('org-bullets').setup({
--     concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
--     symbols = {
--         list = "•",
--         headlines = {"◉", "○", "✸", "✿"},
--         checkboxes = {
--             half = {"", "OrgTSCheckboxHalfChecked"},
--             done = {"✓", "OrgDone"},
--             todo = {"˟", "OrgTODO"}
--         }
--     }
-- })

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'

vim.cmd [[autocmd ColorScheme * hi link OrgHideLeadingStars Normal]]
