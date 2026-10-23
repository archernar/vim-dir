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
