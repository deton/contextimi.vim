" vi:set ts=8 sts=2 sw=2 tw=0:
scriptencoding utf-8

" contextimi.vim - c,s,rコマンドの書き換え元文字列に応じてIMのオン/オフを制御。
"                  日本語が含まれていればIMをオンに切り替え。
"                  日本語が含まれていなければIMをオフに切り替え。
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2014-02-27

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
" @param active 1の場合は、オンにするかどうかを判定。
"   0の場合は、オフにするかどうかを判定。
" @param str cやsコマンドの書き換え元文字列
" @return 1: オンにすると判断した場合、もしくはオフにすると判断した場合。
"   0: 何もしないと判断した場合。
function! s:decideimcfunc_default(active, str)
  " オンにするかどうかの判定
  if a:active
    " 日本語(ASCII以外の文字)が含まれる場合は、オンにする
    if a:str =~ '[^\x00-\x7f]'
      return 1
    else
      return 0
    endif
  else " オフにするかどうかの判定
    " 日本語が含まれない場合は、オフにする
    if a:str !~ '[^\x00-\x7f]'
      return 1
    else
      return 0
    endif
  endif
endfunction

" 行末コメント中に日本語があっても、行頭からCした場合はIMオフにしたい等の
" 判定をしたい場合用
if !exists('contextimi_decideimcfunc')
  let contextimi_decideimcfunc = 's:decideimcfunc_default'
endif
let s:decideimcfunc = function(contextimi_decideimcfunc)

let s:ignorethiscmd = 0

" c,sコマンドの書き換え元文字列に応じて、IMをオンにしたりオフにしたり
function! s:imcontrol_cs()
  " a,i等ではv:operatorはsetされないので古い値が残ったまま
  if s:ignorethiscmd == 0 && (v:operator ==? 'c' || v:operator ==? 's')
    call s:onoff(@@)
    return
  endif
  let s:ignorethiscmd = 0
endfunction

function! s:SetIgnoreThisCmd(cmd)
  let s:ignorethiscmd = 1
  return a:cmd
endfunction

function! s:onoff(str)
  if s:decideimcfunc(1, a:str)
    call s:activatefunc(1)
  elseif s:decideimcfunc(0, a:str)
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

" cとsの場合のみ制御したいが、InsertEnterだけではa等との区別が付けられないので
nnoremap <expr> a <SID>SetIgnoreThisCmd('a')
nnoremap <expr> A <SID>SetIgnoreThisCmd('A')
nnoremap <expr> i <SID>SetIgnoreThisCmd('i')
nnoremap <expr> I <SID>SetIgnoreThisCmd('I')
nnoremap <expr> o <SID>SetIgnoreThisCmd('o')
nnoremap <expr> O <SID>SetIgnoreThisCmd('O')
" rに対しては、InsertEnterで&imiを変えても効かないようなので
nnoremap <expr> r <SID>imcontrol_r()

augroup ContextImi
  autocmd!
  autocmd InsertEnter * call <SID>imcontrol_cs()
augroup END
