# Defined in - @ line 1
function gp --wraps='cd ~/Projects/' --description 'alias gp cd ~/Projects/'
  cd ~/Projects/ $argv;
end
