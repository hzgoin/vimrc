inoremap jj <esc>

cnoreabbrev Ack Ack!

set fileformats=unix,dos,mac

"golang filetype START <leader>f+alpha
"autocmd FileType go nmap <leader><leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader><leader>r  <Plug>(go-run)
"autocmd FileType go nmap <leader><leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader><leader>tf  <Plug>(go-test-func)
autocmd FileType go nmap <leader><leader>gtf  <Plug>(go-tests)
autocmd FileType go nmap <leader><leader>gta  <Plug>(go-tests-all)

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

let g:go_fmt_command = "goimports"

"golang filetype END

