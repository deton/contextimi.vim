# `c`,`s`,`r`���ޥ�ɤǽ񤭴�������ʸ����˱�����IM����/���դ��ڤ��ؤ���ץ饰����

���ʤ�tutcode keymap��Ȥä����ܸ�����Ϥ��Ƥ���ΤǤ�����
�������������Խ����ˡ�
�ؿ�̾�񤭴������κݤˤ��Ӥ������ܸ����Ϥ򥪥դˤ�������
���Ƥ��뤳�Ȥ˵��Ť��ޤ�����

�񤭴������δؿ�̾��ASCIIʸ�������ȤäƤ��ʤ��Τǡ�
�����������Ϻǽ餫�����ܸ����Ϥϥ��դˤ��Ƥ������ߤ�����
�Ȼפä��ΤǤ��Υץ饰�������ޤ�����

�ʲ��ε�ǽ���󶡤��ޤ���

* ASCIIʸ�����`c`��`s`�ǽ񤭴�����ݤϡ�IM�򥪥դ��ڤ��ؤ�
* ���ܸ�ʸ�����`c`��`s`�ǽ񤭴�����ݤϡ�IM�򥪥���ڤ��ؤ�

�Ȥ��Ϥ᤿�Ф���Ǥ��������ΤȤ���ۤȤ�ɰ��´��ʤ��Ȥ��Ƥ��ޤ���
("ASCII��"��"���ܸ��"�˽񤭴����褦�Ȥ����
IM���դˤʤäƤ���Ĥ����ȤϤ���ޤ�����
�񤭴�������ʸ����˲ä��ơ����������ʸ���ޤǸ������������Τ���)

## IM�Υ���/���դ��ڤ��ؤ�����
IM�Υ���/���դ��ڤ��ؤ�����ϡ��ǥե���ȤǤ�
`&iminsert`���ͤ�2��0�����ꤹ�뤳�ȤǹԤ��ޤ���(Windows��gvim�ξ��ʤɡ�)

����¾��IM�ڤ��ؤ���ˡ�˴ؤ��Ƥϡ��ʲ��򻲹ͤˤ��Ƥ���������

* [https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-japanese/ime-control](���ܸ����ϸ���⡼��)
* `'imactivatekey'`�ط�
 * https://github.com/koron/imcsc-vim/
 * [http://www.kaoriya.net/blog/2013/07/15/](Ubuntu���Vim��IME(ibus)����)
 * [https://github.com/vim-jp/issues/issues/444](CUI�Ǥ�imaf/imsf��Ȥ����� - Issue #444 - vim-jp/issues - GitHub)

IM�ڤ��ؤ���ˡ�Υ������ޥ����򤷤������ϡ�
IM�ڤ��ؤ���Ԥ��ؿ���������ơ�
���δؿ�̾��`contextimi_activatefunc`�����ꤷ�Ƥ�������
(�ʲ���������⻲��)��
�ؿ��ΰ�����`'imactivatefunc'`��Ʊ���Ǥ���

## IM����/�����ڤ��ؤ���Ԥ����ɤ�����Ƚ����ˡ�Υ������ޥ���

IM�Υ���⤷���ϥ��դ�ɬ�פ���Ƚ�ꤹ�뤿��δؿ���������ơ�
���δؿ�̾��`contextimi_decideimcfunc`�����ꤷ�Ƥ�������
(�ʲ���������⻲��)��

�㤨�С�����������������ܸ줬����Ԥǡ�
��Ƭ����`C`���ޥ�ɤ�Ȥ���IM������ڤ��ؤ��ޤ�����
�����ǤϤʤ���IM���դ��ڤ��ؤ�������硢����Ƚ���Ԥ��ؿ���������ơ�
`contextimi_decideimcfunc`���ץ��������ꤷ�Ƥ���������

## ������: tcvime(1.5.0)��tutcodep keymap�ξ��

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
  " IME���դˤ��ʤ������Ϥ����ݤ�ʸ�����ޤޤ����ϥ��դˤ���
  " tutcodep keymap�ξ�硢�������������桦������ʸ����lmap����Ǥ�ľ�����ϲ�
  if a:str =~ '[^-0-9 -+:<-@[-`{-~]'
    return -1
  endif
  return 0
endfunction
let contextimi_decideimcfunc = 'TcvimeDecideImControl'
```

## ��ĥ��: `a`,`i`,`o`���ޥ�ɤؤ��б�
������`a`,`i`,`o`���ޥ�ɤˤ�̤�б��Ǥ���

���Υץ饰����ˤ��IM����/�������椬��
�桼���ΰտޤȰۤʤ��ڤ��ؤ������ˤ˹Ԥ��Ȥ����äƼ���ʤΤǡ�
���ޤ�տޤ��鳰��ʤ�������`c`,`s`,`r`����ޤ��б����Ƥ��ޤ���

`a`�����б�����ˤϡ��������������ʸ���˱����ƹԤ����Ȥˤʤ�Ȼפ��ޤ���
* �������������ʸ����ξ���Ȥ�ASCII�ʤ�IM����
* �������������ʸ����ξ���Ȥ����ܸ�ʤ�IM����
* ������������ASCII�ǹ����ξ���IM����
* ���������������ܸ�ǹ����ξ���IM����

## ��Ϣ
* `'imactivatekey'`�ط�
 * https://github.com/koron/imcsc-vim/
 * [http://www.kaoriya.net/blog/2013/07/15/](Ubuntu���Vim��IME(ibus)����)
 * [https://github.com/vim-jp/issues/issues/444](CUI�Ǥ�imaf/imsf��Ȥ����� - Issue #444 - vim-jp/issues - GitHub)
* [https://github.com/vim-jp/issues/issues/13](IME��ON/OFF��syntax�����椹�� - Issue #13 - vim-jp/issues - GitHub)
* [https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-japanese/ime-control](���ܸ����ϸ���⡼��)
