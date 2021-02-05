inoremap jj <esc>

cnoreabbrev Ack Ack!

set fileformats=unix,dos,mac

"golang filetype ========START <leader>f+alpha
"autocmd FileType go nmap <leader><leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader><leader>r  <Plug>(go-run)
"autocmd FileType go nmap <leader><leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader><leader>tf  <Plug>(go-test-func)
autocmd FileType go nmap <leader><leader>gtf :GoTests<CR>
autocmd FileType go vmap <leader><leader>gtf :GoTests<CR>
autocmd FileType go nmap <leader><leader>gta :GoTestsAll

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader><leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader><leader>c  <Plug>(go-coverage-toggle)

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go nmap <leader><leader>a :call go#alternate#Switch(0, 'edit')<CR>
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go nmap <leader><leader>av :call go#alternate#Switch(0, 'vsplit')<CR>
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go nmap <leader><leader>as :call go#alternate#Switch(0, 'split')<CR>
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
autocmd Filetype go nmap <leader><leader>at :call go#alternate#Switch(0, 'tabe')<CR>

let g:go_fmt_command = "goimports"
let g:go_highlight_generate_tags = 1
let g:go_auto_sameids = 1
" let g:go_metalinter_autosave = 1
" let g:go_metalinter_command = "golangci-lint"
" let g:go_def_mode = 'guru'

"golang filetype =========END

