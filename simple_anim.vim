execute "normal! gg"
execute "visual! Gd"
redraw

let HEIGHT = 12
let WIDTH  = 20

for i in range(HEIGHT)
    execute "normal! ". WIDTH . "ix\<Esc>o\<Esc>"
endfor


call cursor(1,1)


for i in range(10)
    let line = getcurpos()[1]
    let col  = getcurpos()[2]
    call cursor(line + 1, col + 1)
    execute "normal! s0\<Esc>"
    redraw
    sleep 200 m
endfor
