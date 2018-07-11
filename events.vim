
let g:symbol = 'x'

function! ToggleSymbol()
    if g:symbol == 'x'
        let g:symbol = 'o'
    else
        let g:symbol = 'x'
    endif
endfunction


nmap <silent> j :call ToggleSymbol()<CR>


function! MainLoop(timer)
   execute "normal! i" . g:symbol . "\<Esc>"
   redraw
   " new waiting for CursorHoldEvent
"   call feedkeys("f\e")
endfunction

let timer = timer_start(1000, 'MainLoop', {'repeat': -1})
