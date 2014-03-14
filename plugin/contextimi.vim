" vi:set ts=8 sts=2 sw=2 tw=0:
scriptencoding utf-8

" contextimi.vim - c,s,rコマンドの書き換え元文字列に応じてIMのオン/オフを制御。
"                  日本語が含まれていればIMをオンに切り替え。
"                  日本語が含まれていなければIMをオフに切り替え。
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2014-03-14

if exists('g:loaded_contextimi')
  finish
endif
let g:loaded_contextimi = 1

" cf. 'imactivatefunc'
function! s:activatefunc_default(active)
  if a:active
    set imi=2
  else
    set imi=0
  endif
endfunction

if !exists('contextimi_activatefunc')
  let contextimi_activatefunc = 's:activatefunc_default'
endif
let s:activatefunc = function(contextimi_activatefunc)

" IMのオンもしくはオフが必要かを判定するための関数
" @param str cやsコマンドの書き換え元文字列
" @return 1: オンにすると判断した場合。-1: オフにすると判断した場合。
"   0: 何もしないと判断した場合。
function! s:decideimcfunc_default(str)
  " 日本語(ASCII以外の文字)が含まれる場合は、オンにする
  if a:str =~ '[^\x00-\x7f]'
    return 1
  endif
  " 日本語が含まれない場合は、オフにする
  if a:str !~ '[^\x00-\x7f]'
    return -1
  endif
  return 0
endfunction

" 行末コメント中に日本語があっても、行頭からCした場合はIMオフにしたい等の
" 判定をしたい場合用
if !exists('contextimi_decideimcfunc')
  let contextimi_decideimcfunc = 's:decideimcfunc_default'
endif
let s:decideimcfunc = function(contextimi_decideimcfunc)

let s:iscscmd = 0

" c,sコマンドの書き換え元文字列に応じて、IMをオンにしたりオフにしたり
function! s:imcontrol_cs()
  if s:iscscmd
    call s:onoff(@@)
    return
  endif
endfunction

function! s:onoff(str)
  let res = s:decideimcfunc(a:str)
  if res > 0
    call s:activatefunc(1)
  elseif res < 0
    " 書き換え対象文字列が、IMEオフにしないと入力が面倒な場合はオフにする
    " (IMEオンでも直接入力可能な文字列の場合はオフにしない)
    call s:activatefunc(0)
  endif
endfunction

function! s:imcontrol_r()
  let curch = matchstr(getline('.'), '\%' . col('.') . 'c.')
  call s:onoff(curch)
  return 'r'
endfunction

function! s:set_iscscmd(cmd)
  let s:iscscmd = 1
  return a:cmd
endfunction

function! s:reset_iscscmd()
  let s:iscscmd = 0
endfunction

nnoremap <expr> c <SID>set_iscscmd('c')
nnoremap <expr> C <SID>set_iscscmd('C')
nnoremap <expr> s <SID>set_iscscmd('s')
nnoremap <expr> S <SID>set_iscscmd('S')

" rに対しては、InsertEnterで&imiを変えても効かないようなので
nnoremap <expr> r <SID>imcontrol_r()

augroup ContextImi
  autocmd!
  autocmd InsertEnter * call <SID>imcontrol_cs()
  autocmd InsertLeave * call <SID>reset_iscscmd()
augroup END
