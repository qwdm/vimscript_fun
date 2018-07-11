
"set t_ve=

" CONST
let HEIGHT = 20
let WIDTH  = 40
let BORDER = '#'
let SNAKE  = '0'
let RABBIT = '*'
let INIT_LEN = 7
let GROW_RATE = 5

" SNAKE
let snake = []
let direction = 'right'
let to_grow = 0

" RABBIT
let rabbit = [HEIGHT/4, WIDTH/3]


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

"""""""""""""""""""""""""""""""""""
"" RANDOM
"""""""""""""""""""""""""""""""""""

let random = localtime() % 997

function Random()
    let g:random = (171 * g:random) % 30269
    return g:random
endfunction
""""""""""""""""""""""""""""""""""


""" snake """

function SnakeInit()
    for i in range(g:INIT_LEN)
        call add(g:snake, [g:HEIGHT/2, g:WIDTH/2 - i]) 
    endfor

    call SnakeDraw()
endfunction

function SnakeMove()

    let head = g:snake[0]
    let new_head = copy(head)

    let state = 'default'
    
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

    let under_head_char = GetCh(new_head[0], new_head[1])

    if under_head_char == g:BORDER || under_head_char == g:SNAKE
        let state = 'gameover'
        return state
    elseif under_head_char == g:RABBIT
        let state = 'rabbit'
        let g:to_grow += g:GROW_RATE
    endif

    if g:to_grow == 0
        let cut = 2
    else
        let cut = 1
        let g:to_grow -= 1
    endif

    let g:snake = [new_head] + g:snake[:len(g:snake) - cut]

    return state

endfunction

function SnakeDraw()
    for point in g:snake
        call PutCh(point[0], point[1], g:SNAKE)
    endfor
endfunction

function MainLoop(timer)
    let timer = a:timer 
     
    call FillSpaces()

    call DrawBorder()
    call SnakeDraw()
    call RabbitDraw()

    let state = SnakeMove()

    if state == 'gameover'
        call timer_stop(timer)
    elseif state == 'rabbit'
        call RabbitInit()
    endif

    redraw
endfunction

""""""""
" rabbit
"

function RabbitInit()
    while 1
        let column = Random() % g:WIDTH        
        let line   = Random() % g:HEIGHT

        let char = GetCh(line, column)

        if char == ' '
            let g:rabbit = [line, column]
            break
        endif

    endwhile
    
endfunction

function RabbitDraw()
    call PutCh(g:rabbit[0], g:rabbit[1], g:RABBIT)
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAIN 
"

echo "SNAKE GAME IN PURE VIMSCRIPT"
sleep 1
call SnakeInit()
call MainLoop(0)
call RabbitInit()


nmap <silent> i :let direction = 'up'<CR>
nmap <silent> j :let direction = 'left'<CR>
nmap <silent> l :let direction = 'right'<CR>
nmap <silent> k :let direction = 'down'<CR>


let timer = timer_start(100, 'MainLoop', {'repeat': -1})
