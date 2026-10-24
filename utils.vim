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
