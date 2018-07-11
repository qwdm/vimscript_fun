
"set t_ve=

" CONST
let HEIGHT = 20
let WIDTH  = 40
let BORDER = '#'
let SNAKE  = '0'
let INIT_LEN = 13

" SNAKE
let snake = []
let direction = 'right'

function FillSpaces()
    normal! gg
    for line in range(1, g:HEIGHT)
        call setline(line, GetNSpaces(g:WIDTH))
    endfor
endfunction

function DrawBorder()
    for pos in range(1, g:WIDTH)
        call PutCh(1, pos, g:BORDER)
        call PutCh(g:HEIGHT, pos, g:BORDER)
    endfor

    for pos in range(1, g:HEIGHT)
        call PutCh(pos, 1, g:BORDER)
        call PutCh(pos, g:WIDTH, g:BORDER)
    endfor
endfunction


function GetCh(line, column)
    let line = a:line 
    let column = a:column 

    return getline(line)[column - 1]
endfunction


function PutCh(line, column, char)

    let line = a:line 
    let column = a:column 
    let char = a:char 

    call cursor(line, column)
    execute "normal! s" . char . "\e"

endfunction


""" snake """

function SnakeInit()
    for i in range(g:INIT_LEN)
        call add(g:snake, [g:HEIGHT/2, g:WIDTH/2 - i]) 
    endfor
endfunction

function SnakeMove()

    let head = g:snake[0]
    let new_head = copy(head)
    
    if g:direction == 'right'
        let new_head[1] += 1
    elseif g:direction == 'left'
        let new_head[1] -= 1
    elseif g:direction == 'up'
        let new_head[0] -= 1
    elseif g:direction == 'down'
        let new_head[0] += 1
    endif

    let new_head[0] = (new_head[0] + g:HEIGHT) % g:HEIGHT
    let new_head[1] = (new_head[1] + g:WIDTH)  % g:WIDTH

    let g:snake = [new_head] + g:snake[:len(g:snake)-2]

endfunction

function SnakeDraw()
    for point in g:snake
        call PutCh(point[0], point[1], g:SNAKE)
    endfor
endfunction

function! MainLoop(timer)
    call FillSpaces()
    call DrawBorder()
    call SnakeMove()
    call SnakeDraw()
    redraw
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAIN 
"
call SnakeInit()


nmap <silent> i :let direction = 'up'<CR>
nmap <silent> j :let direction = 'left'<CR>
nmap <silent> l :let direction = 'right'<CR>
nmap <silent> k :let direction = 'down'<CR>


let timer = timer_start(100, 'MainLoop', {'repeat': -1})
