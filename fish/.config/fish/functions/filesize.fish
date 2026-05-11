function filesize --wraps='du -sh' --description 'alias filesize=du -sh'
    du -sh $argv
end
