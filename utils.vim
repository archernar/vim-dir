" *****************************************************************************************************
" *****************************************************************************************************
                "  utils.vim - 
                "
                " *************************************************************************************
                "


function! g:GetVimVersionString() abort
    let l:major = v:version / 100
    let l:minor = v:version % 100
    return printf('%d.%d', l:major, l:minor)
endfunction


function! g:Log(msg)
    " Specify your log file path
    let l:logfile = expand('~/.vim/debug.log')
    " Format message with a timestamp
    let l:entry = strftime('%Y-%m-%d %H:%M:%S') . ': ' . a:msg
    " Append to file (list of lines, file path, append mode)
    call writefile([l:entry], l:logfile, 'a')
endfunction


function! g:SystemCommand(...)
    execute a:1
endfunction


function! g:JumpToLineWithStr(search_str)
    let l:last_line = line('$')

    " Loop through every line in the current buffer from top to bottom
    for l:i in range(1, l:last_line)
        " Check if the line contains the search string literally
        if stridx(getline(l:i), a:search_str) != -1
            " Move cursor to the matching line (column 1)
            call cursor(l:i, 1)
            return l:i
        endif
    endfor

    " Echo a message if the string wasn't found in the buffer
    echo "String not found: " . a:search_str
    return 0
endfunction


function! g:StartsWith(prefix, str) abort
    return stridx(a:str, a:prefix) == 0
endfunction


function! g:RemovePrefix(prefix, str) abort
    if stridx(a:str, a:prefix) == 0
        " Slice the string starting from the byte-length of the prefix
        return strpart(a:str, strlen(a:prefix))
    endif
    return a:str
endfunction


function! g:NewWindow(...)
        " for wincmdH is Left  L is Right  K is Top  J is Bottom
        " H is Left  L is Right  K is Top  J is Bottom
        vnew
        let l:sz = tolower(a:1)

        if (l:sz == "left")
             wincmd H
        else
            if (l:sz == "right")
                 wincmd L
            else
                if (l:sz == "top")
                     wincmd K
                else
                    if (l:sz == "bottom")
                         wincmd J
                    endif
                endif
            endif
        endif

        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
        nnoremap <silent> <buffer> q :close<cr>
"       nnoremap <silent> <buffer> = :vertical resize +5<cr>
"       nnoremap <silent> <buffer> - :vertical resize -5<cr>
        nnoremap <silent> <buffer> = :exe "vertical resize +" . winwidth(0)/4<cr>
        nnoremap <silent> <buffer> - :exe "vertical resize -" . winwidth(0)/4<cr>
        call cursor(1, 1)
        execute "vertical resize " . a:2
        if ( a:0 > 2)
            execute "nnoremap <silent> <buffer> " . a:3 . "<cr>"
        endif
        if ( a:0 > 3)
            execute "nnoremap <silent> <buffer> " . a:4 . "<cr>"
        endif
        if ( a:0 > 4)
            execute "nnoremap <silent> <buffer> " . a:5 . "<cr>"
        endif
        if ( a:0 > 5)
            execute "nnoremap <silent> <buffer> " . a:6 . "<cr>"
        endif
        if ( a:0 > 6)
            execute "nnoremap <silent> <buffer> " . a:7 . "<cr>"
        endif
        if ( a:0 > 7)
            execute "nnoremap <silent> <buffer> " . a:8 . "<cr>"
        endif
        if ( a:0 > 8)
            execute "nnoremap <silent> <buffer> " . a:9 . "<cr>"
        endif
        if ( a:0 > 9)
            execute "nnoremap <silent> <buffer> " . a:10 . "<cr>"
        endif
endfunction
