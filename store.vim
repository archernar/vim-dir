" ============================================================================
" Name/Value Pair Store
" ============================================================================
" This script implements a simple, robust key-value store with disk I/O.
"
" Key Vim 8 practices used:
" * s:store       - Uses script-local scope (s:) to prevent global pollution.
" * abort         - Ensures that if an error occurs, execution stops.
" * get()         - Highly optimized built-in Dict function for safe retrieval.
" * remove()      - Built-in Dict function for safe deletion.
" * a:0 / a:1     - Handles variadic arguments for optional default values.
" * json_encode() - Native Vim 8 JSON serialization for saving to disk.
" * json_decode() - Native Vim 8 JSON deserialization for loading from disk.
" * writefile() / readfile() - Standard Vim functions for file I/O.
" ============================================================================

source ~/.vim/bundle/vim-dir/popup.vim
" Define the script-local dictionary to act as the store
let s:store = {}

" ----------------------------------------------------------------------------
" StorePut(name, value)
" Adds a name/value pair to the store. 
" Overwrites the value if the name already exists.
" ----------------------------------------------------------------------------
function! StorePut(name, value) abort
    let s:store[a:name] = a:value
endfunction

" ----------------------------------------------------------------------------
" StoreGet(name, [default])
" Retrieves a value by its name. 
" Takes an optional second argument as a default value if the key is missing.
" ----------------------------------------------------------------------------
function! StoreGet(name, ...) abort
    " a:0 is the number of extra arguments. a:1 is the first extra argument.
    let l:default = a:0 > 0 ? a:1 : v:null
    return get(s:store, a:name, l:default)
endfunction

" ----------------------------------------------------------------------------
" StoreChange(name, value)
" Updates an existing name/value pair.
" Returns 1 on success, or throws an error/returns 0 if the name doesn't exist.
" ----------------------------------------------------------------------------
function! StoreChange(name, value) abort
    if has_key(s:store, a:name)
        let s:store[a:name] = a:value
        return 1
    else
        echoerr "StoreChange: Name '" . a:name . "' does not exist."
        return 0
    endif
endfunction

" ----------------------------------------------------------------------------
" StoreDelete(name)
" Removes a name/value pair from the store.
" Returns the deleted value on success, or throws an error if it doesn't exist.
" ----------------------------------------------------------------------------
function! StoreDelete(name) abort
    if has_key(s:store, a:name)
        return remove(s:store, a:name)
    else
        echoerr "StoreDelete: Name '" . a:name . "' does not exist."
        return 0
    endif
endfunction

" ----------------------------------------------------------------------------
" StoreSave(filepath)
" Serializes the store to JSON and writes it to the specified file path.
" Returns 1 on success, 0 on failure.
" ----------------------------------------------------------------------------
function! StoreSave(filepath) abort
    try
        let l:json = json_encode(s:store)
        " writefile expects a list of lines, so we wrap the JSON string in a list
        call writefile([l:json], a:filepath)
        return 1
    catch
        echoerr "StoreSave: Failed to write to " . a:filepath
        return 0
    endtry
endfunction

" ----------------------------------------------------------------------------
" StoreLoad(filepath)
" Reads JSON from the specified file path and populates the store.
" Returns 1 on success, 0 on failure.
" ----------------------------------------------------------------------------
function! StoreLoad(filepath) abort
    if !filereadable(a:filepath)
        echoerr "StoreLoad: File not readable at " . a:filepath
        return 0
    endif

    try
        let l:lines = readfile(a:filepath)
        if !empty(l:lines)
            let l:decoded = json_decode(l:lines[0])
            " Ensure the decoded JSON is actually a dictionary before assigning
            if type(l:decoded) == v:t_dict
                let s:store = l:decoded
                return 1
            else
                echoerr "StoreLoad: JSON root is not a dictionary."
                return 0
            endif
        endif
    catch
        echoerr "StoreLoad: Failed to parse JSON from " . a:filepath
        return 0
    endtry
endfunction

" ----------------------------------------------------------------------------
" StoreDump()
" Optional Utility: Returns a copy of the entire store for inspection.
" ----------------------------------------------------------------------------
function! StoreDump() abort
    return deepcopy(s:store)
endfunction


" ============================================================================
" USAGE EXAMPLES
" ============================================================================
" To test these out, uncomment the lines below and source this file (:source %).
" Let's define a temporary file to save our store:
" let s:test_file = expand('~/.vim_store_data.json')
"
" " 1. Put some values
" call StorePut('theme', 'dark')
" call StorePut('tab_size', 4)
"
" " 2. Save the store to disk
" call StoreSave(s:test_file)
" echo "Saved data to " . s:test_file
"
" " 3. Clear the store locally to prove it loads from disk
" call StoreDelete('theme')
" call StoreDelete('tab_size')
" echo "Store cleared: " . string(StoreDump())
"
" " 4. Load the store from disk
" call StoreLoad(s:test_file)
" echo "Store loaded: " . string(StoreDump())
"
" " 5. Change and Get a loaded value
" call StoreChange('tab_size', 2)
" echo "New tab size is: " . StoreGet('tab_size')
" ============================================================================
