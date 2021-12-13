" *****************************************************************************************************
                "  dir.vim - a Simple Directory Lister/File Opener
                " *************************************************************************************
if exists("g:loaded_plugin_dir") || v:version < 700 || &cp
  finish
endif
let g:loaded_plugin_dir=1

" *****************************************************************************************************
                "  Command definitions
                " *************************************************************************************
command! UPDATEVIMDIR  :PluginUpdate vim-dir
command! VIMDIR        :PluginUpdate vim-dir
command! CODE          :call s:MyDirCode(0)
command! SNIPS         :call s:MyDirSnips(0)
command! DIRE          :call s:MyDirSelect($VIMSELECTEDDIR,0)
command! J             :call s:MyDirJSnips(0)
command! A             :call s:MyDirAllSnips(0)
command! JN            :call s:NewSnip()
command! FRESH         :call g:FreshSnip()
command! FRESHTHIS     :call g:BuffertoSnip()
command! QRS           :call g:CourseSnip()
command! COURSE        :call g:CourseSnip()
command! PUSHSNIPS     :! cd /etc/air/scm/vim-progsnips;git add plugin/*.txt;git commit -m "Update";git push -u origin master

command! JSNIPS        :call s:MyDirJSnips(0)
command! CLASSES       :call s:MyDirClasses(0)
command! B             :call s:MyVimBuffers(1)
command! DIR           :call s:MyDirPwd(1)
command! DIRC          :call s:MyDirPwd(0)
command! DDIR          :call s:MyDirPwd(0)


" *****************************************************************************************************
                "  Local/Script Functions
                " *************************************************************************************
let s:DirSet = ""
let s:DirMask = "/*"
let s:DirEditWindow=0
let s:DirCloseWindow=1
let s:DirWindow=0
function! s:DirSetMask(...)
    let s:DirMask = a:1
    return  s:DirMask
endfunction
function! s:DirFileName(...)
    return  join(split(a:1,"/")[-1:-1])
endfunction
function! s:DirToken(...)
    let l:ret = ""
    if (strlen(a:1) > 0)
        let l:ret = split(a:1," ")[-1]
    endif
    return l:ret
endfunction
function! s:DirSetPwd()
    let s:DirSet = getcwd()
    return s:DirSet
endfunction
function! s:DirSetUp()
    let s:DirSet = (s:DirSet == "/") ? "/" : ("/" . join( (split(s:DirSet,"/"))[:-2], "/" ))
    return s:DirSet
endfunction
function! s:DirSetInto(...)
    let s:DirSet = (a:1 == "") ?  s:DirSet : s:DirSet . "/" . a:1
    return s:DirSet
endfunction
let s:PutLineRow=0
function! s:PutLineSet(...)
    let s:PutLineRow = a:1 
endfunction
function! s:PutLine(...)
    call setline(s:PutLineRow, a:1)
    let s:PutLineRow = s:PutLineRow + 1
endfunction

function! g:CourseSnip()
    let l:repo = "/etc/air/scm/vim-progsnips"
    let l:dir = l:repo . "/plugin"
    let l:fname=expand('%:r')
    if (isdirectory(l:dir))
        let l:name = "QRS"
        let l:name = toupper(l:name) . "-" . toupper(l:fname)  . ".txt"
        execute "w " . l:dir . "/" .l:name
        execute "cd " . l:repo . ";git add plugin/*.txt;git commit -m 'Update';git push -u origin master"
    else
        echom l:dir . " directory does not exist"
    endif
endfunction
function! g:BuffertoSnip()
    let l:dir = "/etc/air/scm/vim-progsnips/plugin"
    let l:fname=expand('%:r')
    if (isdirectory(l:dir))
        let l:name = input('Enter snip prefix name: ')
        let l:name = toupper(l:name) . "-" . toupper(l:fname)  . ".txt"
        execute "w " . l:dir . "/" .l:name
    else
        echom l:dir . " directory does not exist"
    endif
endfunction
function! g:FreshSnip()
    let l:dir = "/etc/air/scm/vim-progsnips/plugin"
    if (isdirectory(l:dir))
        let l:name = input('Enter snip file name: ')
        let l:name = toupper(l:name) . ".txt"
        execute "e " . l:dir . "/" .l:name
    else
        echom l:dir . " directory does not exist"
    endif
endfunction

function! s:NewSnip()
    let l:name = input('Enter file name: ')
    let l:name = "J" . l:name
    let l:name = toupper(l:name) . ".txt"
    let  l:dir="/etc/mdisks/scm/vim-progsnips/plugin/"
    execute "e " . l:dir . l:name
endfunction

function! g:VIMBUFFERS(...)
    call s:MyVimBuffers(a:1)
endfunction

function! s:MyVimBuffers(...)
    call s:PutLineSet(0)
    " Load Buffer Part
        let l:list = []
        let l:forcetype = "b"
                let l:c=1
                while l:c <= 64 
                    if (bufexists(l:c))
                        if (filereadable(bufname(l:c)))
                            if (getbufvar(l:c, '&buftype') == "")
                                if !(bufname(l:c) == "")
                                   call add(list, l:c . " " . bufname(l:c) ) 
                                endif
                            endif
                        endif
                    endif
                    let l:c += 1
                endwhile 
    " Create Window/Buffer Part
        call s:NewWindow("Left", &columns/3, "<Enter> :call g:MyBufferAction()","s :call g:MyBufferAction()", "b :call g:MyBufferAction()")
        let s:DirWindow = winnr()
        nnoremap <silent> <buffer> f /^f<cr>
        echom "<enter> to select"
    " Display Part
        setlocal cursorline
        call s:PutLineSet(1)

        call s:PutLine("Vim Buffers")
        let l:templ = []

	for key in l:list
          let l:type=l:forcetype
          "call add(l:templ, l:type . " " . key)
          call s:PutLine(l:type . " " . key)
	endfor

	"for key in sort(l:templ)
        "  call s:PutLine(key)
	"endfor

        set nowrap
endfunc
function! s:MyDir(...)
    call s:PutLineSet(0)
    " Load Directory Part
        let l:forcetype = "f"
        let l:list = split(glob(a:1),'\n')
    " Create Window/Buffer Part
        call s:NewWindow("Left", &columns/4, "<Enter> :call g:MyDirAction('e')","s :call g:MyDirAction('vnew')", "b :call g:MyDirAction('split')")
        let s:DirWindow = winnr()
        nnoremap <silent> <buffer> w <C-W>w
        nnoremap <silent> <buffer> W <C-W>w
        nnoremap <silent> <buffer> f /^f<cr>
        nnoremap <silent> <buffer> a /^f A<cr>
        nnoremap <silent> <buffer> A /^f A<cr>
        nnoremap <silent> <buffer> j /^f J<cr>
        nnoremap <silent> <buffer> J /^f J<cr>
        nnoremap <silent> <buffer> k /^f K<cr>
        nnoremap <silent> <buffer> K /^f K<cr>
        nnoremap <silent> <buffer> v /^f V<cr>
        nnoremap <silent> <buffer> V /^f V<cr>
        echom "<enter> to edit, <s> to edit in Vert-Split, <b> to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        call s:PutLineSet(1)

        " call s:PutLine("[" . s:DirSet . "]")
        call s:PutLine("[" . g:Strreplace(s:DirSet,$HOME,"$HOME") . "]")
        call s:PutLine("..")
        let l:templ = []

	for key in l:list
          let l:sz = s:DirFileName(key)
          let l:type=l:forcetype
          if (isdirectory(s:DirSet . "/" . l:sz) > 0)
               let l:type="d"
          endif
          call add(l:templ, l:type . " " . l:sz)
	endfor

	for key in sort(l:templ)
          call s:PutLine(key)
	endfor
        set nowrap
endfunc

function! s:NewWindow(...)
        " for wincmdH is Left  L is Right  K is Top  J is Bottom
        " H is Left  L is Right  K is Top  J is Bottom
        vnew
        let l:sz = tolower(a:1)
        if (l:sz == "left")
             wincmd H
        endif
        if (l:sz == "right")
             wincmd L
        endif
        if (l:sz == "top")
             wincmd K
        endif
        if (l:sz == "bottom")
             wincmd J
        endif
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
        nnoremap <silent> <buffer> q :close<cr>
        nnoremap <silent> <buffer> = :vertical resize +5<cr>
        nnoremap <silent> <buffer> - :vertical resize -5<cr>
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
endfunction


" *****************************************************************************************************
                "  Global/Public Functions
                " *************************************************************************************
function! g:ListBuffers()
    let l:c=1
    call s:NewWindow("Left", &columns/4)
    call s:PutLine(1)
    while l:c <= 64 
        if (bufexists(l:c))
            if (filereadable(bufname(l:c)))
                if (getbufvar(l:c, '&buftype') == "")
                    if !(bufname(l:c) == "")
                       call s:PutLine( l:c . " " . bufname(l:c) ) 
                    endif
                endif
            endif
        endif
        let l:c += 1
    endwhile 
endfunction
function! s:MyDirSelect(...)
    let  s:DirCloseWindow = a:2
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific(a:1) 
    call s:MyDir(a:1 . s:DirMask)
endfunction

function! g:DIRPWD(...)
    call s:MyDirPwd(a:1)
endfunction

function! s:MyDirPwd(...)
    let s:DirCloseWindow = a:1
    let s:DirEditWindow = winnr()
    call s:DirSetPwd() 
    call s:MyDir("." . s:DirMask)
endfunction
function! s:DirSetSpecific(...)
    let s:DirSet = a:1
    return s:DirSet
endfunction
function! s:MyDirCode(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific("/etc/air/CC") 
    call s:MyDir("/etc/air/CC" . s:DirMask)
endfunction
function! s:MyDirSnips(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    let  l:dir="/.vim/bundle/vim-progsnips/plugin" 
    call s:DirSetSpecific($HOME . l:dir) 
    call s:MyDir($HOME . l:dir . s:DirMask)
endfunction
function! s:MyDirClasses(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific($HOME . "/classes") 
    call s:MyDir($HOME . "/classes/*.class")
endfunction


function! g:JAVASNIPS(...)
    call s:MyDirAllSnips(a:1)
endfunction


function! s:MyDirJSnips(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    let  l:dir="/.vim/bundle/vim-progsnips/plugin" 
    call s:DirSetSpecific($HOME . l:dir) 
    call s:MyDir($HOME . l:dir . "/J*.txt")
endfunction

function! g:ALLSNIPS(...)
    call s:MyDirAllSnips(a:1)
endfunction
function! s:MyDirAllSnips(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    let  l:dir="/.vim/bundle/vim-progsnips/plugin" 
    call s:DirSetSpecific($HOME . l:dir) 
    call s:MyDir($HOME . l:dir . "/*.txt")
endfunction

function! g:MyBufferAction()
          if (getline(".") != "Vim Buffers")
              let l:ret = split(getline(".")," ")[-1]
              exe "q"
              execute "b " . l:ret
          endif
endfunction

function! g:MyDirAction(...)
     let l:sz   = s:DirToken(getline("."))
     if (line(".") > 1) 
         if (strlen(l:sz) > 0)
             if (l:sz == "..")
                 silent execute "q"
                 let l:sz = s:DirSetUp()
                 call s:MyDir(s:DirSet . s:DirMask)
                 return
             endif
             let l:fs = s:DirSet . "/" . l:sz
             if ( isdirectory(s:DirSet . "/" . l:sz) == 0 )
                 echom l:fs . "   "  .  filereadable(l:fs)
                 if (filereadable(l:fs))

                            "silent execute "q"
                            "silent execute a:1 . " " . l:fs
                            exe s:DirEditWindow+1 . "wincmd w"
                            execute "read " . l:fs
                            normal! k
                            exe s:DirEditWindow . "wincmd w"
if (0 > 1) 

                             if (s:DirCloseWindow == 1)
                                 silent execute "q"
                             endif
                             exe s:DirEditWindow+1 . "wincmd w"
                             silent execute a:1 . " " . l:fs
                             if (s:DirCloseWindow == 0)
                                 exe s:DirWindow . "wincmd w"
                             endif
endif



                 endif
             else
                 silent execute "q"
                 call s:DirSetInto(l:sz)
                 call s:MyDir(s:DirSet . s:DirMask)
             endif
         endif
     endif
endfunction
