# `c`,`s`,`r`コマンドで書き換え前の文字列に応じてIMオン/オフを切り替えるプラグイン

普段はtutcode keymapを使って日本語を入力しているのですが、
ソースコード編集時に、
関数名書き換え等の際にたびたび日本語入力をオフにする操作を
していることに気づきました。

書き換え前の関数名はASCII文字しか使っていないので、
こういう場合は最初から日本語入力はオフにしておいて欲しい、
と思ったのでこのプラグインを作りました。

以下の機能を提供します。

* ASCII文字列を`c`や`s`で書き換える際は、IMをオフに切り替え
* 日本語文字列を`c`や`s`で書き換える際は、IMをオンに切り替え

使い始めたばかりですが、今のところほとんど違和感なく使えています。
("ASCIIで"を"日本語で"に書き換えようとすると
IMオフになっていらつくことはありました。
書き換え前の文字列に加えて、その前後の文字まで見る方がいいのかも)

## IMのオン/オフの切り替え制御
IMのオン/オフの切り替え制御は、デフォルトでは
`&iminsert`の値を2や0に設定することで行います。(Windowsのgvimの場合など。)

その他のIM切り替え方法に関しては、以下を参考にしてください。

* [https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-japanese/ime-control](日本語入力固定モード)
* `'imactivatekey'`関係
 * https://github.com/koron/imcsc-vim/
 * [http://www.kaoriya.net/blog/2013/07/15/](Ubuntu上のVimでIME(ibus)制御)
 * [https://github.com/vim-jp/issues/issues/444](CUIでもimaf/imsfを使いたい - Issue #444 - vim-jp/issues - GitHub)

IM切り替え方法のカスタマイズをしたい場合は、
IM切り替えを行う関数を定義して、
その関数名を`contextimi_activatefunc`に設定してください
(以下の設定例も参考)。
関数の引数は`'imactivatefunc'`と同じです。

## IMオン/オフ切り替えを行うかどうかの判定方法のカスタマイズ

IMのオンもしくはオフが必要かを判定するための関数を定義して、
その関数名を`contextimi_decideimcfunc`に設定してください
(以下の設定例も参考)。

例えば、行末コメント中に日本語がある行で、
行頭から`C`コマンドを使うとIMオンに切り替えますが、
そうではなく、IMオフに切り替えたい場合、その判定を行う関数を作成して、
`contextimi_decideimcfunc`オプションに設定してください。

## 設定例: tcvime(1.5.0)とtutcodep keymapの場合

```vim:.vimrc
function! TcvimeActivate(active)
  if a:active
    call tcvime#EnableKeymap()
  else
    call tcvime#DisableKeymap()
  endif
endfunction
let contextimi_activatefunc = 'TcvimeActivate'

function! TcvimeDecideImControl(str)
  if a:str =~ '[^\x00-\x7f]'
    return 1
  endif
  " IMEオフにしないと入力が面倒な文字が含まれる場合はオフにする
  " tutcodep keymapの場合、数字・一部記号・一部大文字はlmapオンでも直接入力可
  if a:str =~ '[^-0-9 -+:<-@[-`{-~]'
    return -1
  endif
  return 0
endfunction
let contextimi_decideimcfunc = 'TcvimeDecideImControl'
```

## 拡張案: `a`,`i`,`o`コマンドへの対応
現状は`a`,`i`,`o`コマンドには未対応です。

このプラグインによるIMオン/オフ制御が、
ユーザの意図と異なる切り替えを頻繁に行うとかえって邪魔なので、
あまり意図から外れなさそうな`c`,`s`,`r`からまず対応しています。

`a`等に対応するには、カーソル前後の文字に応じて行うことになると思います。
* カーソル前後の文字が両方ともASCIIならIMオフ
* カーソル前後の文字が両方とも日本語ならIMオン
* カーソル前がASCIIで行末の場合はIMオフ
* カーソル前が日本語で行末の場合はIMオン

## 関連
* `'imactivatekey'`関係
 * https://github.com/koron/imcsc-vim/
 * [http://www.kaoriya.net/blog/2013/07/15/](Ubuntu上のVimでIME(ibus)制御)
 * [https://github.com/vim-jp/issues/issues/444](CUIでもimaf/imsfを使いたい - Issue #444 - vim-jp/issues - GitHub)
* [https://github.com/vim-jp/issues/issues/13](IMEのON/OFFをsyntaxで制御する - Issue #13 - vim-jp/issues - GitHub)
* [https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-japanese/ime-control](日本語入力固定モード)
