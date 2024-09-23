function db --wraps='nvim +DBUI' --description 'alias db nvim +DBUI'
  nvim --cmd "let g:auto_session_enabled = v:false" +DBUI $argv
end
