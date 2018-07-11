
"for i in range(10)
"    let line = getcurpos()[1]
"    let col  = getcurpos()[2]
"    call cursor(line + 1, col + 1)
"    execute "normal! s0\<Esc>"
"    redraw
"    sleep 200 m
"endfor


python3 << PYTHONEND

import vim
import time
import sys

print(sys.version)

def getcurpos():
    _, cursor_line, cursor_column, *_ = vim.eval("getcurpos()")
    return cursor_line, cursor_column

#def setcurpos(line, column):
#    vim.execute("call cursor

print("hello")

#vim.command('execute "normal! s0\<Esc>"')

print(getcurpos())
print()

PYTHONEND
