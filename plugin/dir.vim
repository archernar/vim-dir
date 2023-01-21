" *****************************************************************************************************
                "  dir.vim - a Simple Directory Lister/File Opener
                " *************************************************************************************
if exists("g:loaded_plugin_dir") || v:version < 700 || &cp
  finish
endif
let g:loaded_plugin_dir=1

let s:READFILEACTION = 0
let s:OPENFILEACTION = 1
let s:CLOSESPLITAFTERACTION = 0
let s:OPENSPLITAFTERACTION = 1
let s:KEEPSPLITOPEN = 0

" *****************************************************************************************************
                "  Command definitions
                " *************************************************************************************
command! UPDATEVIMDIR  :PluginUpdate vim-dir
command! VIMDIR        :PluginUpdate vim-dir
command! CODE          :call s:MyDirCode(0)
command! SNIPS         :call s:MyDirSnips(0)
command! DIRE          :call s:MyDirSelect($VIMSELECTEDDIR,0)
command! PROJ          :call s:MyDirProjectSnips(0)
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

" https://vim.fandom.com/wiki/Get_the_name_of_the_current_file


function! s:PathFileName(...)                  " Given a full filename path, return the filename part
    return fnamemodify(a:1, ':t')
    remap <Leader>k :call g:DIRSELECTOPEN($HOME . "/projects/*.project")<cr>

endfunction
function! s:PathLastDirectory(...)             " Given a full filename path, return the last directoryi name only
    return fnamemodify(a:1, ':p:h:t')
endfunction
function! s:PathFullDirectory(...)             " Given a full filename path, return thei path to the filename
    return fnamemodify(a:1, ':p:h')
endfunction

function! s:FileNameExtension(...)
    return split(a:1,"[.]")[-1]
endfunction
function! s:DirFileNameExtension(...)
    return split(a:1,"[.]")[-1]
endfunction

function! s:FileNameFirstPart(...)
    return split(a:1,"[.]")[0]
endfunction
function! s:FileNameSecondPart(...)
    return split(a:1,"[.]")[1]
endfunction
function! s:FileNameMiddlePart(...)
    return split(a:1,"[.]")[1]
endfunction
function! s:FileNameThirdPart(...)
    return split(a:1,"[.]")[2]
endfunction
function! s:FileNameLastPart(...)
    return split(a:1,"[.]")[-1]
endfunction

function! s:FileNameBookEnds(...)
    let l:nRet = 0
    if (split(a:1,"[.]")[0] == a:2) 
        if (split(a:1,"[.]")[-1] == a:3)
            let l:nRet = 1
        endif
    endif
    return l:nRet
endfunction
function! s:FileNameIs(...)
    let l:nRet = 0
    if (a:1 == a:2) 
            let l:nRet = 1
    endif
    return l:nRet
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
    let l:tag = "QRS"
    let l:repo = "/etc/air/scm/vim-progsnips"
    let l:dir = l:repo . "/plugin"
    let l:fname=expand('%:r')
    call g:Strreplace(l:fname,l:tag . "-","")
    call g:Strreplace(l:fname,l:tag . "-","")
    call g:Strreplace(l:fname,l:tag . "-","")

    if (isdirectory(l:dir))
        let l:name = l:tag
        let l:name = toupper(l:name) . "-" . toupper(l:fname)  . ".txt"
        execute "w! " . l:dir . "/" .l:name
        let l:cmd = "!cd " . l:repo . ";git add plugin/*.txt;git commit -m 'Update';git push -u origin master"
        execute l:cmd
       " execute "cd " . l:repo . ";git add plugin/*.txt;git commit -m 'Update';git push -u origin master"
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
        let l:CommandType = a:1
        call s:PutLineSet(0)
    " Load Directory Part
        let l:forcetype = "f"
        if (a:0 == 2)
            let l:list = split(glob(a:2),'\n')
        else
            if (a:0 == 3)
                let l:list = split(glob(a:2),'\n') + split(glob(a:3),'\n')
            else
                if (a:0 == 4)
                    let l:list = split(glob(a:2),'\n') + split(glob(a:3),'\n') + split(glob(a:4),'\n')
                else
                    if (a:0 == 5)
                        let l:list = split(glob(a:2),'\n') + split(glob(a:3),'\n') + split(glob(a:4),'\n') + split(glob(a:5),'\n')
                    endif
                endif
            endif
        endif

    " Create Window/Buffer Part
    " 8 Args
        call s:NewWindow("Left", &columns/4, "<Enter> :call g:MyDirAction('r')", "x :call g:MyDirAction('e')", "n :call g:MyDirAction('n')", "p :call g:MyDirAction('p')", "v :call g:MyDirAction('v')","q :call g:MyDirAction('q')")
        echom "<r> edit snip, <enter> read snip into current buffer, <l> load session file, <p> open and load project"

        let s:DirWindow = winnr()
        nnoremap <silent> <buffer> <F1> <Nop>
        nnoremap <silent> <buffer> q :close<cr>
        nnoremap <silent> <buffer> w <C-W>w
        nnoremap <silent> <buffer> W <C-W>w
        nnoremap <silent> <buffer> f /^f<cr>
        " For Examples
        nnoremap <silent> <buffer> e /^f E[.]<cr>
        nnoremap <silent> <buffer> E /^f E[.]<cr>
        " For Professor's site
        nnoremap <silent> <buffer> p /^f P[.]<cr>
        nnoremap <silent> <buffer> P /^f P[.]<cr>

        nnoremap <silent> <buffer> l /^f L<cr>
        nnoremap <silent> <buffer> L /^f L<cr>
        nnoremap <silent> <buffer> a /^f A<cr>
        nnoremap <silent> <buffer> A /^f A<cr>
        nnoremap <silent> <buffer> j /^f J<cr>
        nnoremap <silent> <buffer> J /^f J<cr>
        nnoremap <silent> <buffer> k /^f K<cr>
        nnoremap <silent> <buffer> K /^f K<cr>
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

function! s:AssertExecution(...)
    silent execute a:1
endfunc

function! s:NewWindow(...)
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
    call s:MyDir(0, a:1 . s:DirMask)
endfunction

function! g:DIRPWDACTION(...)
    " a:1 is split close t/f
    " a:2 is slection action
    let s:DirCloseWindow = a:1
    let s:DirEditWindow = winnr()
    call s:DirSetPwd() 
    call s:MyDir(a:2, "." . s:DirMask)
endfunction

function! g:DIRPWD(...)
    call s:MyDirPwd(a:1)
endfunction
function! s:MyDirPwd(...)
    let s:DirCloseWindow = a:1
    let s:DirEditWindow = winnr()
    call s:DirSetPwd() 
    call s:MyDir(0, "." . s:DirMask, "./.*")
endfunction



function! s:DirSetSpecific(...)
    let s:DirSet = a:1
    return s:DirSet
endfunction
function! s:MyDirCode(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific("/etc/air/CC") 
    call s:MyDir(0, "/etc/air/CC" . s:DirMask)
endfunction
function! s:MyDirSnips(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    let  l:dir="/.vim/bundle/vim-progsnips/plugin" 
    call s:DirSetSpecific($HOME . l:dir) 
    call s:MyDir(0, $HOME . l:dir . s:DirMask)
endfunction
function! s:MyDirClasses(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific($HOME . "/classes") 
    call s:MyDir(0, $HOME . "/classes/*.class")
endfunction


function! g:JAVASNIPS(...)
    call s:MyDirAllSnips(a:1)
endfunction

function! g:DIRSELECTOPEN(...)
    "full path with wildcards
    " open of close window on action
    call s:MyDirSelector(a:1, 1)
endfunction
function! g:DIRSELECTCLOSE(...)
    "full path with wildcards
    " open of close window on action
    call s:MyDirSelector(a:1, 0)
endfunction


"  function! s:PathFileName(...)
"  function! s:PathLastDirectory(...)
"  function! s:PathFullDirectory(...)
function! s:MyDirSelector(...)
    let  s:DirCloseWindow = a:2
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific(s:PathFullDirectory(a:1))
    call s:MyDir(1, a:1)
endfunction


function! s:MyDirJSnips(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    let  l:dir="/.vim/bundle/vim-progsnips/plugin" 
    call s:DirSetSpecific($HOME . l:dir) 
    call s:MyDir(0, $HOME . l:dir . "/J*.txt")
endfunction

function! g:ALLSNIPS(...)
    call s:MyDirAllSnips(a:1)
endfunction
function! s:MyDirAllSnips(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    let  l:dir="/.vim/bundle/vim-progsnips/plugin" 
    call s:DirSetSpecific($HOME . l:dir) 
    call s:MyDir(0, $HOME . l:dir . "/*.txt", $HOME . l:dir . "/*.vim", $HOME . "/projects/*.project")
endfunction

function! g:MyBufferAction()
          if (getline(".") != "Vim Buffers")
              let l:ret = split(getline(".")," ")[-1]
              exe "q"
              execute "b " . l:ret
          endif
endfunction

"if !empty(glob("path/to/file"))
function! g:IsTextish(...)
    let l:ret = 0
    let l:body = []
    if (filereadable(a:1))
        let l:body = readfile(a:1)
        if ( l:body[0] == a:2)
            let l:ret = 1
        endif
    endif
    let l:body = []
    return l:ret
endfunction
function! g:Textish(...)
    let l:body = []
    if (filereadable(a:1))
        let l:body = readfile(a:1)
        if ( l:body[0] == a:2)
            let l:temp = remove(l:body, 0)
            exe s:DirEditWindow+1 . "wincmd w"
            for l:item in l:body
                exe "set paste"
                exe "normal! o" . l:item . "\<Esc>"
                exe "set nopaste"
            endfor
            exe "normal! o" . "\<Esc>"
        endif
    endif
endfunction

function! g:MyDirAction(...)
     let l:sz   = s:DirToken(getline("."))
     if (line(".") > 1) 
         if (strlen(l:sz) > 0)
             if (l:sz == "..")
                 silent execute "q"
                 let l:sz = s:DirSetUp()
                 call s:MyDir(0, s:DirSet . s:DirMask)
                 return
             endif
             let l:fs = s:DirSet . "/" . l:sz
             if ( isdirectory(s:DirSet . "/" . l:sz) == 0 )
                 " echom l:fs . "   "  .  filereadable(l:fs)
                 "if (filereadable(l:fs))
                 if (1==1)
                     if (a:1 == 'n')
                                "silent execute "q"
                                "silent execute a:1 . " " . l:fs
                                exe s:DirEditWindow+1 . "wincmd w"
                                execute "enew"
                                execute "r " . l:fs
                                normal! k
                     endif
                     if (a:1 == 'p')
                                exe  "cd /etc/air/scm/" . s:FileNameMiddlePart(l:sz) 
                                exe  "pwd"
                                silent execute "q"
                                "call DIRPWD(s:KEEPSPLITOPEN)
                                let l:sz = "/etc/air/scm/" . s:FileNameMiddlePart(l:sz)  . "/.vim.vimsession"
                                if (filereadable(l:sz))
                                   silent execute "bufdo! bd"
                                   execute "call LoadSession()"
                                   else
                                       echom "No session file (.vim.vimsession)"
                                endif
                     endif
                     if (a:1 == 'l')
                                if ( s:FileNameIs(l:sz, ".vim.vimsession") )
                                    silent execute "q"
                                    silent execute "bufdo! bd"
                                    execute "call LoadSession()"
                                else
                                        echom "Not a session file"
                                endif
                     endif
                     if (a:1 == 'r')
                                if (s:FileNameBookEnds(l:sz, "A", "vim") == 0)
                                    if (s:FileNameBookEnds(l:sz, "A", "project") == 0)
                                        exe s:DirEditWindow+1 . "wincmd w"
                                        execute "r " . l:fs
                                        normal! k
                                    endif
                                endif
                     endif
                     if (a:1 == 'v')
                                if (s:FileNameBookEnds(l:sz, "A", "vim") == 1)
                                    exe s:DirEditWindow+1 . "wincmd w"
                                    execute "e " . "/etc/air/scm/vim-progsnips/plugin/" . l:sz 
                                endif
                     endif
                     if (a:1 == 'q')
                                if (s:FileNameBookEnds(l:sz, "A", "vim") == 1)
                                    exe s:DirEditWindow+1 . "wincmd w"
                                    exe "!cd /etc/air/scm/vim-progsnips; A.add " . s:FileNameMiddlePart(l:sz) . ";"
                                endif
                     endif
                     if (a:1 == 'e')
                                if (s:FileNameBookEnds(l:sz, "A", "vim") == 1)
                                    if (g:IsTextish(l:fs,"THISTEXT") == 1)
                                        call g:Textish(l:fs,"THISTEXT")
                                    else
                                        exe s:DirEditWindow+1 . "wincmd w"
                                        let l:thisCurrentLine = line(".")
                                        exe  "call g:" . s:FileNameMiddlePart(l:sz) . "()"
                                        silent execute "" . l:thisCurrentLine
    "                                   normal! k
    "                                   exe s:DirEditWindow . "wincmd w"
    "                                   silent execute "q"
                                    endif
                                else
                                    if (s:FileNameBookEnds(l:sz, "B", "txt") == 1)
                                        call g:Textish(l:fs,"THISTEXT")
                                    else
                                        if (s:FileNameBookEnds(l:sz, "A", "project") == 1)
                                            " let l:ninnnn = input("DEBUG2>> [" . "STOP" . "][" . s:FileNameMiddlePart(l:sz) . "]")
                                            exe  "cd /etc/air/scm/" . s:FileNameMiddlePart(l:sz) 
                                            exe  "pwd"
                                            silent execute "q"
                                            call DIRPWD(s:KEEPSPLITOPEN)
                                        else
                                            if (s:FileNameBookEnds(l:sz, "A", "txt") == 1)
                                                let s:body = []
                                                if (filereadable(l:fs))
                                                    let s:body = readfile(l:fs)
                                                    if ( s:body[0] == "THISTEXT")
                                                        let i = remove(s:body, 0)
                                                        exe s:DirEditWindow+1 . "wincmd w"
                                                        for s:item in s:body
                                                            exe "set paste"
                                                            exe "normal! o" . "" . s:item . "" . "\<Esc>"
                                                            exe "set nopaste"
                                                        endfor
                                                        exe "normal! o" . "" . "" . "" . "\<Esc>"
                                                    endif
                                                endif
                                            else
                                                if (s:DirFileNameExtension(l:sz) == "txt")
                                                        exe s:DirEditWindow+1 . "wincmd w"
                                                        execute "e " . l:fs
                                                        normal! k
                                                        exe s:DirEditWindow . "wincmd w"
                                                else
                                                        "silent execute "q"
                                                        "silent execute a:1 . " " . l:fs
                                                        exe s:DirEditWindow+1 . "wincmd w"
                                                        execute "e " . l:fs
                                                        normal! k
                                                        exe s:DirEditWindow . "wincmd w"
                                                endif 
                                            endif 
                                        endif 
                                    endif 
                                endif 

                     endif 
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
                 call s:MyDir(0, s:DirSet . s:DirMask)
             endif
         endif
     endif
endfunction
