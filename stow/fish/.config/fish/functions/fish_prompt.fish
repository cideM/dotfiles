set __fish_git_prompt_show_informative_status 1

set __fish_git_prompt_char_dirtystate '+'
set __fish_git_prompt_char_invalidstate 'x'
set __fish_git_prompt_char_stagedstate '*'
set __fish_git_prompt_char_untrackedfiles 'u'
set __fish_git_prompt_char_untrackedfiles 'u'
set __fish_git_prompt_char_stateseparator '|'

function fish_prompt
    set_color $fish_color_cwd
    echo -n (basename $PWD)
    fish_git_prompt
    set_color normal
    echo -n ' λ '
end
