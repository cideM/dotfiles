if exists('g:loaded_zen')
  finish
endif

command! StartZenMode lua require'zen'.start_zen_mode()

let g:loaded_zen = 1
