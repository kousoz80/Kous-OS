//  oreore Basic ver 0.01
// oreore-OS上で動作するBASICインタプリタ

// プログラム構造体
 struct Program
   long prev# // 前の行
   long next# // 次の行
   long lineno#      // 行番号
   long label#       // ラベルのチェックサム(ラベルが無いときは-1)
   long text#        // テキスト先頭文字
 end


// 値
  struct Value
    long type#
    long data#
  end


// 変数
  struct Variable
    long name#        // 変数名
    long dimension#   // 配列ならば0より大きな数値が入る 
    long dim#
    long dim1#
    long dim2#
    long dim3#
    long dim4#
    long dim5#
    long dim6#
    long dim7#
    long dim8#
    long dim9#
    long value#
    long prev#
    long next#
  end


// FOR文用データ
  long ForStack#,ForStackP#
  struct  _ForStack
    long var#     // ループ変数へのポインタ
    long limit#   // ループ変数上限値
    long step#    // STEP値
    long program# // リピートTEXT行記憶用
    long token_p# // リピート有効文字先頭
  end


// GOSUB文用データ
  long GosubStack#,GosubStackP#
  struct  _GosubStack
    long program#  // リターンする行記憶用
    long token_p#  // リターンする文字先頭
  end


// BASICのコマンド
  struct _Command
    long keyword#
    long func#
  end

// BASICの関数
  struct _Function
    long keyword#
    long func#
  end

Command:
  data "run",cmd_run
  data "if",cmd_if
  data "for",cmd_for
  data "next",cmd_next
  data "goto",cmd_goto
  data "gosub",cmd_gosub
  data "return",cmd_return
  data "print",cmd_print
  data "input",cmd_input
  data "clear",cmd_clear
  data "pset",cmd_pset
  data "cls",cmd_cls
  data "line",cmd_line
  data "locate",cmd_locate
  data "dim",cmd_dim
  data "open",cmd_open
  data "close",cmd_close
  data "box",cmd_box
  data "boxf",cmd_boxf
  data "circle",cmd_circle
  data "circlef",cmd_circlef
//  data "start",cmd_start
  data "exec",cmd_exec
  data "wait",cmd_wait
  data "image",cmd_image
  data "save",cmd_save
  data "edit",cmd_edit
  data "load",cmd_load
  data "new",cmd_new
//  data "let",cmd_let
  data "end",cmd_end
  data "list",cmd_list
  data "run",cmd_run
  data "bye",cmd_quit
  data "stop",cmd_stop
  data "cont",cmd_cont
  data "color",cmd_color
//  data "make",cmd_make
  data NULL,NULL

Function:
 data "abs",func_abs
//  data "int",func_int
  data "abs",func_abs
//  data "sqr",func_sqr
//  data "exp",func_exp
//  data "log",func_log
//  data "sin",func_sin
//  data "cos",func_cos
//  data "tan",func_tan
//  data "atn",func_atn
  data "chr$",func_chrs
  data "asc",func_asc
  data "mid$",func_mids
  data "left$",func_lefts
  data "right$",func_rights
  data "input$",func_inputs
  data "inkey$",func_inkeys
//  data "eof",func_eof
  data "str$",func_strs
  data "val",func_val
  data "len",func_len
//  data "time$",func_times
//  data "date$",func_dates
//  data "instr",func_instr
//  data "rnd",func_rnd
//  data "netstat",func_netstat
  data NULL,NULL

// プログラムを消去する
clear_program:
  TopProg, prog#=
  
  clear_program1:
    if prog#=NULL goto clear_program2
    prog#, pp#=
    pp#, ->Program.next# prog#=
    pp#, ->Program.text# free
    pp#, free
    goto clear_program1
  clear_program2:
  NULL, TopProg#= EndProg#=
  end

// 指定されたラベルの位置を返す
// ラベルが見つからないときはNULLを返す
serch_label_position:
  str#= pop lbl#=
  
//  "serch label position:", prints
//  "lbl: ", prints lbl#, printd nl
//  "str: ", prints  str#, prints nl
//  " start serch:", prints nl
  
  TopProg#, pp#=
serch_label_position1:
  if pp#=NULL then NULL, end
  pp#, ->Program.label# tt#=
  
//  "lbl=", prints
//  tt#, printd nl
  
  if tt#<>lbl# goto serch_label_position4
  pp#, ->Program.text# ss#=
serch_label_position2:
  ss#, is_space tt#=
  if tt#<>0 then ss#++ gotoserch_label_position2
  if (ss)$<>LABEL_HEADER goto serch_label_position4
serch_label_position3:
  ss#, is_symbol_char tt#=
  if tt#=0 then pp#, end
  if (ss)$<>(str)$ goto serch_label_position4
  ss#++
  str#++
  goto serch_label_position3
serch_label_position4:

// "next line:", prints nl

  pp#, ->Program.next# pp#=
  goto serch_label_position1

// 文字列を追加する
append_line:
  str#= ss#=

//  "append line:", prints nl

  NULL, BreakProg#=
  -1, lbl#=   
append_line1:
  (ss)$, is_space tt#=
  if tt#<>0 then ss#++ gotoappend_line1
  if (ss)$<>LABEL_HEADER goto append_line3
  ss#++
  0, lbl#=
append_line2:
  (ss)$, is_symbol_char tt#=
  if tt#<>0 then (ss)$, lbl#, + lbl#= ss#++ gotoappend_line2

  // プログラムが空の場合
append_line3:
  if TopProg#<>NULL goto append_line4
  1, CurrentLineNo#=
  Program.SIZE, malloc TopProg#= EndProg#=
  NULL, TopProg#, ->Program.prev#=
  NULL, TopProg#, ->Program.next#=
  CurrentLineNo#, TopProg#, ->Program.lineno#=
  CurrentLineNo#++
  lbl#, TopProg#, ->Program.label#=
  str#, strlen 1, + malloc TopProg#, ->Program.text#=
  str#, TopProg#, ->Program.text# strcpy
  end

  // プログラムを追加
append_line4:
  Program.SIZE, malloc pp#=
  EndProg#, pp#, ->Program.prev#=
  NULL, pp#, ->Program.next#=
  CurrentLineNo#, pp#, ->Program.lineno#=
  CurrentLineNo#++
  lbl#, pp#, ->Program.label#=
  str#, strlen 1, + malloc pp#, ->Program.text#=
  str#, pp#, ->Program.text# strcpy
  pp#, EndProg#, ->Program.next#=
  pp#, EndProg#=
  end

// BASICのプログラムを最初から実行する
exec_basic:
  CurrentProg#=
  clear_value
  CurrentProg#, ->Program.text# TokenP#= 
  getToken // 最初のトークン切り出し
  CurrentProg#, TokenP#,  exec_basic2
  end

// BASICプログラムを現在のロケーションから継続して実行する
exec_basic2:
 long no#
  TokenP#= pop CurrentProg#=
  
//  "exec basic2:", prints nl
  
  0, status#=
  if CurrentProg#=NULL then "can't continue", assertError

  // ループ
  exec_basic2_1:

    if BreakFlg#=0 goto exec_basic2_2
      0, BreakFlg#=
      CurrentProg#, BreakProg#=
      TokenP#, BreakToken#=
      "Break", assertError

    // トークンがCOMMANDなら次のトークンをとりだしてDISPATCH
    exec_basic2_2:
    if TokenType#<>COMMAND goto exec_basic2_3

//  "exec basic2 command:", prints nl

     TokenCode#, _Command.SIZE, * no#=
      getToken
      Command, no#, + ->@_Command.func status#=
      if status#<>DONE then status#, end
      goto exec_basic2_1

    // トークンが変数なら代入
    exec_basic2_3:
    if TokenType#=VARIABLE then cmd_let gotoexec_basic2_1


    // トークンがEOLなら次の行へ
    if TokenType#<>EOL goto exec_basic2_4

//  "exec basic2 eol:", prints nl

      // 次の行に移る
      CurrentProg#, ->Program.next# CurrentProg#=

      // 最終行(中身無し)に到達すると終了
      if CurrentProg#=NULL then TERMINATE, end

      // テキストポインタを設定
      CurrentProg#, ->Program.text# TokenP#=
      getToken
      goto exec_basic2_1

    // マルチステートメントの処理
    exec_basic2_4:
    if TokenType#<>DELIMIT goto exec_basic2_5

//  "exec basic2 delimit:", prints nl

      if TokenText$=':' then getToken gotoexec_basic2_1
      "Syntax Error", assertError

    // ラベルの場合は無視(1つの行に2個以上ラベルがある場合は、最初のラベル以外は無視されるので注意)
    exec_basic2_5:
    if TokenType#=LABEL then getToken gotoexec_basic2_1

    // 上記以外の場合は文法エラー  

//  "exec basic2 other:", prints nl

    "Syntax Error", assertError
    end

// エラーを発生させる
assertError:
 long mesg#
 mesg#=
 
// "assert error:", prints nl
 
  StackSave#, __stack_p#=
  CurrentProg#, ->Program.lineno# tt#=
  if tt#<=0 then  mesg#, prints nl gotobasic_entry
  "Line ", prints tt#, printd  " : ", prints
  mesg#, prints nl
  if SysError#=1 then end
  goto basic_entry

// プログラムをロードする
load_basic:
  char buf$(MAX_TEXT_LENGTH+1)
  char rfp$(FILE_SIZE)
  long flg#,fname#

  flg#= pop fname#=

// "load basic:", prints nl

  fname#, rfp, ropen tt#=
  if tt#<>ERROR goto load_basic1
    if flg#<>0 then "can't load", assertError
    end
  load_basic1:
  cmd_new
  load_basic2:
     buf, rfp, finputs tt#=
     if tt#=EOF goto load_basic3
     buf, append_line
  goto load_basic2
  load_basic3:
  rfp, rclose
  end

// 文字列を数値に変換する
xval:
  long rss#
  rss#=

  if (rss)$='+' then rss#, 10, atoi end  
  if (rss)$='-' then rss#, 10, atoi end
  if (rss)$<'0' goto xval1  
  if (rss)$>'9' goto xval1
  rss#, 10, atoi end

  xval1:
  if (rss)$<>'&' then 0, end
  if (rss)$(1)='H' then rss#, 2, + 16, atoi end
  if (rss)$(1)='h' then rss#, 2, + 16, atoi end
  if (rss)$(1)='B' then rss#, 2, + 2, atoi end
  if (rss)$(1)='b' then rss#, 2, + 2, atoi end
  rss#, 1, + 8, atoi end

// トークンを切り出してバッファに格納する
getToken:

// "getToken:", prints TokenP#, prints nl

  NULL, TokenText$=
  0, ii#=

  // 空白や制御文字をスキップする
getToken1:
   if (TokenP)$>' ' goto getToken2
     if (TokenP)$=NULL then EOL, TokenType#= end
     TokenP#++
     goto getToken1

  // "'"が現れたときは行の終わり
getToken2:
  if (TokenP)$=A_QUOT then EOL, TokenType#= end

  // 先頭が"であれば次の"までは文字列
  if (TokenP)$<>DBL_QUOT goto getToken4
    STRING, TokenType#=
    TokenP#++
getToken3:
   if (TokenP)$=NULL then "SyntaxError", assertError
   if (TokenP)$<>DBL_QUOT then (TokenP)$, TokenText$(ii#)= TokenP#++ ii#++ gotogetToken3
   TokenP#++
    NULL, TokenText$(ii#)=
//    "string:", prints nl 
    end

  // 先頭がアルファベット
getToken4:
  (TokenP)$, is_symbol_char0 tt#=
  if tt#=0 goto getToken10
  
//  "symbol char:", prints nl
  
getToken5:
  (TokenP)$, is_symbol_char tt#=
  if tt#=1 then  (TokenP)$, TokenText$(ii#)= TokenP#++ ii#++ gotogetToken5
  NULL, TokenText$(ii#)=

//  "TokenText=", prints TokenText, prints nl

    // "else"キーワードが出てきたら行の終わりと判断する
getToken6:
    TokenText, "else", strcmp tt#=
    if tt#=0 then EOL, TokenType#= end

    // Basicのコマンドの場合
    Command, pp#= 0, ii#=
getToken7:
    pp#, ->_Command.keyword# qq#=
    if qq#=NULL goto  getToken8
    TokenText, qq#, strcmp tt#=
    if tt#=0 then  COMMAND, TokenType#= ii#, TokenCode#= end
    pp#, _Command.SIZE, + pp#=
    ii#++
    goto getToken7

    // 関数の場合
getToken8:
    Function, pp#= 0, ii#=
getToken8x:
    pp#, ->_Function.keyword# qq#=
    if qq#=NULL goto  getToken9
    TokenText, qq#, strcmp tt#=
    if tt#=0 then  FUNCTION, TokenType#= ii#, TokenCode#= end
    pp#, _Function.SIZE, + pp#=
    ii#++
    goto getToken8x

    // コマンドでも関数でもないときは変数とみなす
getToken9:
  
//  "variable:", prints nl
  
    VARIABLE, TokenType#= end

  // 先頭がラベルの先頭文字であれば英数字と'_'が続いているところはラベル
getToken10:
  if (TokenP)$<>LABEL_HEADER goto getToken12
    LABEL, TokenType#=
    TokenP#++
    0, TokenCode#=
getToken11:
    (TokenP)$, is_symbol_char tt#=
    if tt#=1 then (TokenP)$, TokenText$(ii#)= TokenCode#, + TokenCode#= TokenP#++ ii#++ gotogetToken11
    NULL, TokenText$(ii#)=
  
//  "label:", prints nl
//  "TokenText=", prints TokenText, prints nl

  
    end

  // 先頭が'&'で始まっている場合が数値
getToken12:
  (TokenP)$, cc#=
  if cc#<>'&' goto getToken20
  NUMBER, TokenType#=
  TokenP#++
  (TokenP)$, cc#=

    // 16進数
  if cc#<>'h' goto getToken15
      TokenP#++
getToken13:
      (TokenP)$, cc#=
      if cc#>='0' then if cc#<='9' goto getToken14
      if cc#>='a' then if cc#<='f'  goto getToken14
      NULL, TokenText$(ii#)=
      TokenText, 16, atoi TokenValue#=
  
//  "hex decimal:", prints nl
//  "TokenText=", prints TokenText, prints nl

  
      end
getToken14:
     cc#, TokenText$(ii#)=
     ii#++
     TokenP#++
     goto getToken13

    // 2進数
getToken15:
  if cc#<>'b' goto getToken18
      TokenP#++
getToken16:
      (TokenP)$, cc#=
      if cc#>='0' then if cc#<='1' goto getToken17
      NULL, TokenText$(ii#)=
      TokenText, 2, atoi TokenValue#=
  
//  "binary:", prints nl
//  "TokenText=", prints TokenText, prints nl

  
      end
getToken17:
     cc#, TokenText$(ii#)=
     ii#++
     TokenP#++
     goto getToken16

    // 8進数
getToken18:
      (TokenP)$, cc#=
      if cc#>='0' then if cc#<='7' goto getToken19
      NULL, TokenText$(ii#)=
      TokenText, 8, atoi TokenValue#=
  
//  "octal:", prints nl
//  "TokenText=", prints TokenText, prints nl

  
      end
getToken19:
     cc#, TokenText$(ii#)=
     ii#++
     TokenP#++
     goto getToken18

    // 10進数
getToken20:
      if cc#<'0' goto getToken23
      if cc#>'9' goto getToken23
      NUMBER, TokenType#=
getToken21:
      (TokenP)$, cc#=
      if cc#>='0' then if cc#<='9' goto getToken22
      NULL, TokenText$(ii#)=
      TokenText, 10, atoi TokenValue#=
  
//  "decimal:", prints nl
//  "TokenText=", prints TokenText, prints nl

  
      end
getToken22:
     cc#, TokenText$(ii#)=
     ii#++
     TokenP#++
     goto getToken21


  /* 上記以外は区切り文字 */
getToken23:
    DELIMIT, TokenType#=
    cc#, TokenText$(ii#)=
    ii#++
    TokenP#++
    (TokenP)$, bb#=
    
    if cc#<>'=' goto getToken24
    if bb#='<' then bb#, TokenText$(ii#)= ii#++ TokenP#++ gotogetToken26 
    if bb#='>' then bb#, TokenText$(ii#)= ii#++ TokenP#++ gotogetToken26 

getToken24:
    if cc#<>'<' goto getToken25
    if bb#='=' then bb#, TokenText$(ii#)= ii#++ TokenP#++ gotogetToken26 
    if bb#='>' then bb#, TokenText$(ii#)= ii#++ TokenP#++ gotogetToken26 

getToken25:
    if cc#<>'>' goto getToken26
    if bb#='=' then bb#, TokenText$(ii#)= ii#++ TokenP#++

getToken26:
    NULL, TokenText$(ii#)=
  
//  "delimitter:", prints nl
//  "TokenText=", prints TokenText, prints nl

 end

// トークンが正しければ次のトークンを読み込み
// トークンが間違っていたらエラーを発生させる
checkToken:
  long token#
  token#=
  
//  "check token:", prints nl
  
  TokenText, token#, strcmp tt#=
  if tt#<>0 then "Syntax Error", assertError
  getToken
  end

// 雑関数
is_space:
  long cc1#
  cc1#=
  if cc1#=' ' then 1, end
  if cc1#=9  then 1, end
  0, end

is_symbol_char0:
  cc1#=
  if cc1#>='a' then if cc1#<='z' goto is_symbol_char0_1
  if cc1#>='A' then if cc1#<='Z' goto is_symbol_char0_1
  if cc1#='_' goto is_symbol_char0_1
  0, end
is_symbol_char0_1:
  1, end

is_symbol_char:
  cc1#=
  if cc1#>='0' then if cc1#<='9' goto is_symbol_char1
  if cc1#>='a' then if cc1#<='z' goto is_symbol_char1
  if cc1#>='A' then if cc1#<='Z' goto is_symbol_char1
  if cc1#='_' goto is_symbol_char1
  if cc1#='$' goto is_symbol_char1
  0, end
is_symbol_char1:
  1, end


  // 変数宣言

  long   JmpEntry#			       // エラー処理用のエントリポイント
  long   StackSave# 
  long   TopProg#          // BASICプログラム最初の行と最後の行
  long   EndProg#          // BASICプログラム最初の行と最後の行
  long   CurrentProg#      // 現在実行中への行へのポインタ
  long  BreakProg#         // 現在実行中への行へのポインタ
  char  TextBuffer$(MAX_TEXT_LENGTH+1) // プログラムテキストのバッファ
  char  TokenText$(MAX_TEXT_LENGTH+1)  // トークンバッファ
  char   VarName$(MAX_TEXT_LENGTH+1)    // 変数名格納エリア
  long   TokenP#           // トークン解析用の文字位置ポインタ
  long   BreakToken# 
  long   TokenType#,TokenCode#  // トークンタイプとコード
  long   TokenValue#    // トークンの値
  char   CalcStack$(Value.SIZE*STACK_SIZE)    // 演算用スタック
  long   CalcStackP#      // 演算スタックポインタ
  long   SysError#       // この変数がセットされたらシステムエラー
  long   TopVar#          // 変数リスト開始値
  long   EndVar#         // 変数リスト終値
  long   ErrorMessage#
  long   BreakFlg#
  long   RunFlg# 
  long   CurrentLineNo#
  long   BasicBusy# 
  char   Xfp$(FILE_SIZE*MAX_FILES)

  count ii#,jj#,kk#,ll#
  count mm#,nn#
  long aa#,bb#,cc#,lbl#,str#
  long pp#,qq#,rr#,ss#,tt#,uu#,vv#,ww#
  long xx#,yy#,zz#
 
 

// 定数

// トークンタイプ
  const VARIABLE              1     // 変数名
  const COMMAND               2     // コマンド名
  const FUNCTION              3     // 関数名
  const NUMBER                4     // 数字表現文字
  const DELIMIT               5     // 区切り文字
  const STRING                6     // 文字列
  const LABEL                 7     // ラベル
  const EOL                   8     // 行末
  const COUNT                 9     // カウンタ型

// 終了コード
  const DONE              1     // 正常終了
  const TERMINATE         2     // TEXT実行を終了
  const QUIT              3     // BASICを終了

  const MAX_DIMENSION     16    // 配列の最大次元
  const MAX_PROGRAM_SIZE  16000 // プログラムTEXT領域のバイトサイズ
  const MAX_TEXT_LENGTH   255   // テキスト行の長さの限界
  const MAX_STR_LENGTH    511   // 文字列の長さの限界
  const MAX_FILES         10    // 開くことのできるファイルの最大数
  const STACK_SIZE        64    // スタックサイズ
  const ALIGNMENT         4     // アドレス境界のアライメント

 const LABEL_HEADER '@'
 const A_QUOT     39
 const DBL_QUOT 34
 
  .data
EOF_STRING:
  data 255

// 画像操作関数一覧


// 作業変数
 long xcolor#,xwidth#,xheight#,bitmap#
 count ix#,iy#
 long px#,py#,gx#,gy#,gx1#,gy1#
 long tx#,ty#,rx#,ry#,ox#,oy#,vx#,vy#
 long vx1#,vy1#,qx#,qy#,co#

// 点を打つ
xdraw_point:
  py#= pop px#=
  if xcolor#=COLOR_CLEAR then end
  py#, xwidth#, * px#, +
  4, * bitmap#, + pp#=
  xcolor#, (pp)!=
  end


// 与えられた座標の色を返す
xget_point:
  py#= pop px#=
  py#, xwidth#, * px#, +
  4, * bitmap#, + pp#=
  (pp)!,  end

  
// 線を引く
// 使用法: gx, gy, gx1, gy1, xdraw_line
xdraw_line:
  gy1#= pop gx1#= pop gy#= pop gx#=
  if xcolor#=COLOR_CLEAR then end

xline:
  gx#, gx1#, - tx#= abs rx#=
  gy#, gy1#, - ty#= abs ry#=
  if ry#>rx# goto xline_y
  if gx#=gx1# then gx#, gy#, xdraw_point end
  
  // モードX
  xline_x:
    1, rx#=
    if tx#<0  then -1, rx#=
    for ix#=0 to tx# step rx#
      ix#, ty#,  * tx#, / gy1#, + ry#=
      ix#, gx1#, + ry#, xdraw_point
    next ix#
    end
    
  xline_y: /* モード　ｙ */
    1, ry#=
    if ty#<0  then -1, ry#=
    for iy#=0 to ty# step ry#
      iy#, tx#,  * ty#, / gx1#, + rx#=
      iy#, gy1#, + rx#, swap xdraw_point
    next iy#
    end
    
// 画像を消去
xgcls:
  xwidth#,  xheight#, * 1, + tt#=
  for ii#=2 to tt#
    xcolor#, (bitmap)!(ii#)=
  next ii#
  end

// 長方形を描いてうめる
// 使用法: gx, gy, gx1, gy1, xfill_rect
xfill_rect: 
  gy1#= pop gx1#= pop gy#= pop gx#=
  if xcolor#=COLOR_CLEAR then end

  1, rx#= ry#=
  if gy#<gy1# then -1, ry#=
  if gx#<gx1# then -1, rx#=
  for iy#=gy1# to gy# step ry#
    for ix#=gx1# to gx# step rx#
      ix#,  iy#, xdraw_point
    next ix#
  next iy#
  end

// 長方形を描く
// 使用法: gx, gy, gx1, gy1, xdraw_rect
xdraw_rect: 
  gy1#= pop gx1#= pop gy#= pop gx#=
  if xcolor#=COLOR_CLEAR then end
  1, rx#= ry#=
  if gy#<gy1# then -1, ry#=
  if gx#<gx1# then -1, rx#=
  for ix#=gx1# to gx# step rx#
    ix#, gy#,  xdraw_point
    ix#, gy1#, xdraw_point
  next ix#
  for iy#=gy1# to gy# step ry#
    gx#,  iy#, xdraw_point
    gx1#, iy#, xdraw_point
  next iy#
  end
  
// 楕円を描いてうめる
// 使用法: gx, gy, gx1, gy1, xfill_circle
xfill_circle:
  xdraw_circle
  ox1#, oy1#, xpaint
  end

// 楕円を描く
// 使用法: gx, gy, gx1, gy1, xdraw_circle
xdraw_circle:
  long ox1#,oy1#
  gy1#= pop gx1#= pop gy#= pop gx#=
  if xcolor#=COLOR_CLEAR then end
  gx#,  vx#=  gy#,  vy#=
  gx1#, vx1#= gy1#, vy1#=
  if gx1#>gx# then gx1#, gx#, swap gx#= swap gx1#=
  if gy1#>gy# then gy1#, gy#, swap gy#= swap gy1#=
  gx#, gx1#, + 2, / ox1#=
  gy#, gy1#, + 2, / oy1#=
  gx#, gx1#, - 2, / qx#=
  if qx#=0 then xline end
  gy#, gy1#, - 2, / qy#=
  if qy#=0 then xline end
  gx#, gx1#=  oy1#, gy1#=
  for ii#=0 to TABLE_N
    qx#, cos2table#(ii#), * 32767, / ox1#, + gx#=
    qy#, sin2table#(ii#), * 32767, / oy1#, + gy#=
    xline
    gx#, gx1#= gy#, gy1#=
  next ii#
  end


// 塗る
xpaint:
  const Q_SIZE   4096
  long   q_buf#(Q_SIZE)
  long   put_p#,get_p#
  
  gy#= pop gx#=
  if xcolor#=COLOR_CLEAR then end
  0, put_p#= get_p#=
  gx#, gy#, xget_point co#=
  if co#=xcolor# then end
  gx#, gy#, xput_pset

  xpaint1:  // うった点の座標を求める
    if get_p#=put_p# then end
    q_buf#(get_p#), vx#=   get_p#++
    q_buf#(get_p#), vy#=   get_p#++
    if get_p#>=Q_SIZE then 0, get_p#=

    // うった点の四方にまた点をうつ
    vx#, 1, + vy#, xput_pset
    vx#, 1,  - vy#, xput_pset
    vy#, 1, + vx#, swap xput_pset
    vy#, 1,  -  vx#, swap xput_pset
  goto xpaint1
  
  //  点をうってその座標を記録する
  xput_pset:
    qy#= pop qx#=
    if qx#<0     then end  // 範囲外ならしない
    if qx#>=xwidth#  then end
    if qy#<0     then end
    if qy#>=xheight# then end
    qx#, qy#, xget_point co#=
    if co#=xcolor# then end // すでに点がうってあるときもしない
    qx#, qy#, xdraw_point
    qx#, q_buf#(put_p#)=  put_p#++
    qy#, q_buf#(put_p#)=  put_p#++
    if put_p#>=Q_SIZE then 0, put_p#=
    end


// 画像を描画
// 使用法: gx, gy, address, xdraw_image
xdraw_image:
  qq#= pop gy#= pop gx#=
  if qq#=NULL then end
  (qq)!, rx#=
  if rx#<0 then end
  if rx#>=xwidth# then end
  qq#, 4, + qq#=
  (qq)!, ry#=
  if ry#<0 then end
  if ry#>=xheight# then end
  qq#, 4, + qq#=
  gx#, rx#, + 1, - gx1#=
  gy#, ry#, + 1, - gy1#=
  for ii#=gy# to gy1#
    for jj#=gx# to gx1#
      ii#, xwidth#, * jj#, +
      4, * bitmap#, + pp#=
      if (qq)$(3)=0 then (qq)!, (pp)!=
      qq#, 4, + qq#=
    next jj#
  next ii#
  jj#, ii#, end
    

// コピーエリアに画像をコピー
// 使用法: gx, gy, gx1, gy1, xcopy_image
xcopy_image:
  gy1#= pop gx1#= pop gy#= pop gx#=
  if gx1#>=xwidth#  then xwidth#,  1, - gx1#= 
  if gy1#>=xheight# then xheight#, 1, - gy1#= 
  copy_area#, qq#=
  gx1#, gx#, - 1, + (qq)!=
  qq#, 4, + qq#=
  gy1#, gy#, - 1, + (qq)!=
  qq#, 4, + qq#=
  for ii#=gy# to gy1#
    for jj#=gx# to gx1#
      ii#, xwidth#, * jj#, +
      4, * bitmap#, + pp#=
      (pp)!, (qq)!=
      qq#, 4, + qq#=
    next jj#
  next ii#
  end


// コピーエリアから貼り付ける
// 使用法: gx, gy, xpaste_image
xpaste_image:
  copy_area#, xdraw_image
  end
    

  
// 文字列描画
xdraw_string:
  long dsx#,dsy#,dsw#,dss#,dsr#
  dss#= pop dsw#= pop dsy#= pop dsx#=
  if xcolor#=COLOR_CLEAR then end
  dsx#, dsw#, + FONT_WIDTH, - dsw#=
  xdraw_string1:
    if (dss)$=NULL then end
    dsx#, dsy#, (dss)$, xdraw_font dsr#=
    dsx#, FONT_WIDTH, + dsx#=
    dss#++
  if dsx#<dsw# goto xdraw_string1
  dsr#, end


// 1文字描画
xdraw_font:
  pp#= pop ty#= pop tx#=
  pp#, FONT_WIDTH, * FONT_HEIGHT, * font_area#, + qq#=
  tx#, FONT_WIDTH-1,  + rx#=
  ty#, FONT_HEIGHT-1, + ry#=
  for ii#=ty# to ry#
     for jj#=tx# to rx#
        if (qq)$<>0 then jj#, ii#, xdraw_point
        qq#++
     next jj#
  next ii#
  ii#, end


 .data

// 三角関数テーブル
  const TABLE_N 256 // 区分点 （全データ数＝３２１）
sin2table: // ｆ（ｘ）＝３２７６７＊ｓｉｎ（ｘ）
  data 0,804,1607,2410
  data 3211,4011,4807,5601
  data 6392,7179,7961,8739
  data 9511,10278,11038,11792
  data 12539,13278,14009,14732
  data 15446,16150,16845,17530
  data 18204,18867,19519,20159
  data 20787,21402,22004,22594
  data 23169,23731,24278,24811
  data 25329,25831,26318,26789
  data 27244,27683,28105,28510
  data 28897,29268,29621,29955
  data 30272,30571,30851,31113
  data 31356,31580,31785,31970
  data 32137,32284,32412,32520
  data 32609,32678,32727,32757
cos2table: /* ｆ（ｘ）＝３２７６７＊ｃｏｓ（ｘ） */
  data 32767,32757,32727,32678
  data 32609,32520,32412,32284
  data 32137,31970,31785,31580
  data 31356,31113,30851,30571
  data 30272,29955,29621,29268
  data 28897,28510,28105,27683
  data 27244,26789,26318,25831
  data 25329,24811,24278,23731
  data 23169,22594,22004,21402
  data 20787,20159,19519,18867
  data 18204,17530,16845,16150
  data 15446,14732,14009,13278
  data 12539,11792,11038,10278
  data 9511,8739,7961,7179
  data 6392,5601,4807,4011
  data 3211,2410,1607,804
  data 0,-805,-1608,-2411
  data -3212,-4012,-4808,-5602
  data -6393,-7180,-7962,-8740
  data -9512,-10279,-11039,-11793
  data -12540,-13279,-14010,-14733
  data -15447,-16151,-16846,-17531
  data -18205,-18868,-19520,-20160
  data -20788,-21403,-22005,-22595
  data -23170,-23732,-24279,-24812
  data -25330,-25832,-26319,-26790
  data -27245,-27684,-28106,-28511
  data -28898,-29269,-29622,-29956
  data -30273,-30572,-30852,-31114
  data -31357,-31581,-31786,-31971
  data -32138,-32285,-32413,-32521
  data -32610,-32679,-32728,-32758
  data -32767,-32758,-32728,-32679
  data -32610,-32521,-32413,-32285
  data -32138,-31971,-31786,-31581
  data -31357,-31114,-30852,-30572
  data -30273,-29956,-29622,-29269
  data -28898,-28511,-28106,-27684
  data -27245,-26790,-26319,-25832
  data -25330,-24812,-24279,-23732
  data -23170,-22595,-22005,-21403
  data -20788,-20160,-19520,-18868
  data -18205,-17531,-16846,-16151
  data -15447,-14733,-14010,-13279
  data -12540,-11793,-11039,-10279
  data -9512,-8740,-7962,-7180
  data -6393,-5602,-4808,-4012
  data -3212,-2411,-1608,-805
  data -1,804,1607,2410
  data 3211,4011,4807,5601
  data 6392,7179,7961,8739
  data 9511,10278,11038,11792
  data 12539,13278,14009,14732
  data 15446,16150,16845,17530
  data 18204,18867,19519,20159
  data 20787,21402,22004,22594
  data 23169,23731,24278,24811
  data 25329,25831,26318,26789
  data 27244,27683,28105,28510
  data 28897,29268,29621,29955
  data 30272,30571,30851,31113
  data 31356,31580,31785,31970
  data 32137,32284,32412,32520
  data 32609,32678,32727,32757
  data 32767,32757,32727,32678
  data 32609,32520,32412,32284
  data 32137,31970,31785,31580

// waitコマンド
cmd_wait:

// "cmd wait:", prints nl

  clear_value
  eval_expression
  get_number  wait
  DONE, end

// clearコマンド
cmd_clear:

// "cmd clear:", prints nl

  clear_value
  clear_variable
  ForStack#, ForStackP#= 
  DONE, end

// closeコマンド
cmd_close:

// "cmd close:", prints nl

  if TokenText$<>'#' goto cmd_close1
    getToken
    TokenValue#, nn#=
    if nn#<0 then "Out of Range", assertError
    if nn#>MAX_FILES then "Out of Range", assertError
    nn#, FILE_SIZE, * Xfp, + fp_adr#=
    if (fp_adr)#(FILE_FP/8)<>NULL then  fp_adr#, wclose NULL, (fp_adr)#(FILE_FP/8)=
    getToken
    DONE, end

cmd_close1:
    for ii#=0 to MAX_FILES-1
      ii#, FILE_SIZE, * Xfp, + fp_adr#=
      if (fp_adr)#(FILE_FP/8)<>NULL then  fp_adr#, wclose NULL, (fp_adr)#(FILE_FP/8)=
    next ii#
    DONE, end

// openコマンド
cmd_open:
  long  fp_adr#,io_flg#,fname0#

// "cmd open:", prints nl

  clear_value
  eval_expression
  "for", checkToken
  0, io_flg#=
  TokenText, "input",   strcmp ss#=
  TokenText, "output", strcmp tt#=
  ss#, tt#, * ss#=
  if ss#<>0 then "Syntax Error", assertError
  if tt#=0 then 1, io_flg#= 
  getToken
  "as", checkToken
  "#",  checkToken
  if TokenType#<>NUMBER then "Syntax Error", assertError
  TokenValue#, nn#=
  
//  "file no=", prints nn#, printd nl
  
  if nn#<0 then "Out of Range", assertError
  if nn#>=MAX_FILES then "Out of Range", assertError
  getToken
  get_string fname0#=
  
//  "file name=", prints fname0#, prints nl
//  "i/o=", prints io_flg#, printd nl

  ERROR, tt#=
  nn#, FILE_SIZE, * Xfp, + fp_adr#=
  if (fp_adr)#(FILE_FP/8)<>NULL then "File already open", assertError
  if io_flg#=1 then  fname0#, fp_adr#, wopen tt#=
  if io_flg#=0 then  fname0#, fp_adr#, ropen  tt#=
  fname0#, free
  if tt#=ERROR then NULL, (fp_adr)#(FILE_FP/8)= "File can't open", assertError
  DONE, end

// dimコマンド
cmd_dim:

// "cmd dim:", prints nl

  long dim#(MAX_DIMENSION)
  char vname$(256)
  long vtype#,dx#,var#
  
    if TokenType#<>VARIABLE then "Syntax Error", assertError
    TokenText, vname, strcpy

//   "dim var=", prints vname, prints nl

    vname, var_type vtype#= 
    getToken
    "(", checkToken
    0, dx#=
    cmd_dim1:
      clear_value
      eval_expression
      if dx#>=MAX_DIMENSION then  "dimension size over", assertError
      get_number tt#=
      if tt#<=0 then "Out of Range", assertError
      tt#, dim#(dx#)= dx#++
      if TokenText$=')' goto cmd_dim2
      ",", checkToken
      goto cmd_dim1

cmd_dim2:
    vname, 0, _variable var#=
    dx#, var#, ->Variable.dimension#=
    dx#--
    1, nn#=
    var#, ->Variable.dim pp#=
    for ii#=0 to dx#
    dim#(ii#), (pp)#(ii#)= 1, + nn#, * nn#=
    next ii#

    // 文字列型配列を初期化
    if vtype#<>STRING goto cmd_dim3
      nn#, 8, * malloc pp#=
      var#, ->Variable.value# ->Value.data#=
      nn#--
      for ii#=0 to nn#
        ALIGNMENT, malloc (pp)#(ii#)=
        "", (pp)#(ii#), strcpy
      next ii#
      goto cmd_dim4

    // 数値型配列を初期化
cmd_dim3:
      nn#, 8, * malloc pp#=
      var#, ->Variable.value# ->Value.data#=
      nn#--
      for ii#=0 to nn#
         0, (pp)#(ii#)=
      next ii#
     
cmd_dim4:
    getToken
    if TokenText$<>','  goto cmd_dim5
    getToken
    goto cmd_dim

cmd_dim5:
  getToken
  DONE, end

// ifコマンド
cmd_if:

// "cmd if:", prints nl

  // 論理式が真ならば"thenをチェックしてその次から始める"
  eval_expression
  get_number tt#=
  if tt#=0 goto cmd_if1
    "then", checkToken
    if TokenType#<>LABEL then DONE, end
    TokenCode#, TokenText, serch_label_position pp#=
    if pp#=NULL then "LABEL not found", assertError
    pp#, CurrentProg#=
    CurrentProg#, ->Program.text# TokenP#= 
    getToken
    DONE, end

  // 行のトークンを逐次検索する
cmd_if1:
    getToken

    // "else"があったらそこから始める
    TokenText, "else", strcmp tt#=
    if tt#<>0 goto cmd_if2
    getToken
    if TokenType#<>LABEL then DONE, end
    TokenCode#, TokenText, serch_label_position pp#=
     if pp#=NULL then "LABEL not found", assertError
     pp#, CurrentProg#=
     CurrentProg#, ->Program.text# TokenP#= 
     getToken
     DONE, end

cmd_if2:
   if TokenType#<>EOL goto cmd_if1
   DONE, end


// returnコマンド
cmd_return:

// "cmd return:", prints nl

  if GosubStackP#<GosubStack# then "return without gosub", assertError
  GosubStackP#, _GosubStack.SIZE, - GosubStackP#=
  GosubStackP#, ->_GosubStack.token_p# TokenP#=
  GosubStackP#, ->_GosubStack.program# CurrentProg#=
  getToken
  DONE, end


// gosubコマンド
cmd_gosub:
  long pp1#
  
//  "cmd gosub:", prints nl
  
  GosubStack#, STACK_SIZE, + tt#=
  if GosubStackP#>=tt# then  "stack overflow (gosub)", assertError

  if TokenType#<>LABEL then "Syntax Error", assertError
  TokenCode#, TokenText, serch_label_position pp1#=
  if pp1#=NULL then "LABEL not found", assertError
  getToken

  CurrentProg#, GosubStackP#, ->_GosubStack.program#=
  TokenP#, GosubStackP#, ->_GosubStack.token_p#= 
  GosubStackP#,  _GosubStack.SIZE, + GosubStackP#=
  pp1#, CurrentProg#=
  CurrentProg#, ->Program.text# TokenP#=
  getToken
  DONE, end

// nextコマンド
cmd_next:

// "cmd next:", prints nl

  long for_var#
  if ForStackP#<=ForStack# then  "next without for", assertError
  ForStackP#, _ForStack.SIZE, - ForStackP#=

  // nextの後に変数名がある場合
  if TokenType#<>VARIABLE goto cmd_next1
    TokenText, get_variable ->Variable.value# ->Value.data ForStackP#, ->_ForStack.var#  - tt#=
    if tt#<>0 then "next without for", assertError
    getToken

  // STEP値をループ変数へ加える
cmd_next1:
  ForStackP#, ->_ForStack.var# for_var#=
  ForStackP#, ->_ForStack.step# (for_var)#, + (for_var)#=

  // 終了条件を満たさなければループエントリーに戻る
  (for_var)#, ForStackP#, ->_ForStack.limit# - ForStackP#, ->_ForStack.step# *  tt#=
  if tt#>0 goto cmd_next2
    ForStackP#, ->_ForStack.token_p# TokenP#=
    ForStackP#, ->_ForStack.program# CurrentProg#= 
    ForStackP#, _ForStack.SIZE, + ForStackP#=
    getToken
cmd_next2:
    DONE, end    

// forコマンド
cmd_for:

// "cmd for:", prints nl

  ForStack#, STACK_SIZE, + tt#=
  if ForStackP#>=tt# then "stack over flow (for-next)", assertError
  if TokenType#<>VARIABLE  then "Syntax Error", assertError

  // ループ変数を確保
  TokenText, 0, _variable ->Variable.value# ->Value.data for_var#= 
  for_var#, ForStackP#, ->_ForStack.var#=

  // ループ変数に初期値代入
  cmd_let

  "to", checkToken

  // ループ変数上限を得る
  clear_value
  eval_expression
  get_number ForStackP#, ->_ForStack.limit#=

  // STEP値がある場合
  TokenText, "step", strcmp tt#=
  if tt#<>0 goto cmd_for1
    getToken
    clear_value
    eval_expression
    get_number ForStackP#, ->_ForStack.step#=
    goto cmd_for2 

  // STEP値が省略された場合
cmd_for1:
  ForStackP#, ->_ForStack.limit# (for_var)#, - tt#=
  if tt#>0  then  1,  ForStackP#, ->_ForStack.step#=
  if tt#=0  then  0,  ForStackP#, ->_ForStack.step#=
  if tt#<0  then  -1, ForStackP#, ->_ForStack.step#=

  // 現在の実行位置をスタックへ保存
cmd_for2:
  CurrentProg#, ForStackP#, ->_ForStack.program#=
  TokenP#, ForStackP#, ->_ForStack.token_p#=
  ForStackP#,  _ForStack.SIZE, + ForStackP#=
  DONE, end

// gotoコマンド
cmd_goto:

// "cmd goto:", prints nl

  1, RunFlg#=
  if TokenType#<>LABEL then "Syntax Error", assertError
  TokenCode#, TokenText, serch_label_position pp#=
  if pp#=NULL then "LABEL not found", assertError
  pp#, CurrentProg#=
  CurrentProg#, ->Program.text# TokenP#=
  getToken
  DONE, end



// inputコマンド
cmd_input:
 long input_var#

  // ファイルから入力
  if TokenText$<>'#' goto cmd_input3
    getToken
    TokenValue#, nn#=
    if nn#<0 then   "Out of Range", assertError
    if nn#>=MAX_FILES then  "Out of Range", assertError
    nn#, FILE_SIZE, * Xfp, + fp_adr#=
    if (fp_adr)#(FILE_FP/8)=NULL  then "File is not oen", assertError
    getToken

      // 変数の場合は入力する
cmd_input1:
      if TokenType#<>VARIABLE goto cmd_input2
      TokenText, 0, get_variable_value input_var#= pop vtype#=
       sss, fp_adr#, finputs
       sss, strlen 1, + tt#=
       if vtype#=STRING   then tt#, malloc (input_var)#= sss, swap strcpy
       if vtype#=NUMBER then sss, xval (input_var)#=
       goto cmd_input1

      // セパレータ ',' or ';'
cmd_input2:
      if TokenType#<>DELIMIT then DONE, end
      if TokenText$=',' then getToken gotocmd_input1
      if TokenText$=';' then getToken gotocmd_input1
      DONE, end

  // コンソールから入力
cmd_input3:
    long is_question#
    1, is_question#=

cmd_input4:

      // 文字列のときはプロンプト文字列を表示する
      if TokenType#=STRING then TokenText, prints getToken gotocmd_input4

      // 変数の場合は入力する
      if TokenType#<>VARIABLE goto cmd_input5
      TokenText, 0, get_variable_value input_var#= pop vtype#=

      if is_question#=1 then "? ", prints
      sss, inputs tt#=
      if tt#=3 then 1, BreakFlg#= // CTRL+Cで中断
      sss, strlen 1, + tt#=
      if vtype#=STRING   then tt#, malloc (input_var)#= sss, swap strcpy
      if vtype#=NUMBER then sss, xval (input_var)#=
      1, is_question#=
      goto cmd_input4

      // セパレータ ',' or ';'
cmd_input5:
      if TokenType#<>DELIMIT then DONE, end
      if TokenText$=',' then 1, is_question#= getToken gotocmd_input4
      if TokenText$=';' then 0, is_question#= getToken gotocmd_input4
      DONE, end

// printコマンド
cmd_print:
  long last_char#
  NULL, last_char#=

// "cmd print:", prints nl

  // print#文
  if TokenText$<>'#' goto cmd_print4

// "print#:", prints nl

    getToken
    if TokenType#<>NUMBER then "Syntax Error",  assertError
    TokenValue#, nn#=
    if nn#<0 then "Out of Range", assertError
    if  nn#>=MAX_FILES then "Out of range", assertError
    nn#, FILE_SIZE, * Xfp, + fp_adr#=
    if (fp_adr)#(FILE_FP/8)=NULL then  "File is not open", assertError
    
    getToken
    if TokenType#=DELIMIT then if TokenText$=':' goto cmd_print4
    if TokenType#=EOL goto cmd_print4
    ",", checkToken
cmd_print1:
    if TokenType#=EOL then NULL, last_char#= gotocmd_print3
    if TokenType#=DELIMIT then if TokenText$=':' goto cmd_print3

      // データの表示
      clear_value
      eval_expression

      // 文字列型データの表示
      value_type typ#=
      if typ#=STRING then get_string ss#= fp_adr#, fprints ss#, free

      // 数値型データの表示
      if typ#=NUMBER then get_number fp_adr#, fprintd

      check_value
      if TokenType#=EOL then NULL, last_char#= gotocmd_print3
      if TokenType#<>DELIMIT then "Syntax Error", assertError
      TokenText$, last_char#=

      // セパレータが':'の場合
      if last_char#=':' goto cmd_print3

      // セパレータが','の場合
      if last_char#<>',' goto cmd_print2
        ',', fp_adr#, putc  // カンマを出力
        getToken
        goto cmd_print1

      // セパレータが';'の場合
cmd_print2:
      if last_char#<>';' then "Syntax Error", assertError
        getToken
        goto cmd_print1

cmd_print3:
    if last_char#<>';' then  fp_adr#, fnl
    DONE, end

  // print文
cmd_print4:

// "print:", prints nl

    if TokenType#=EOL then NULL, last_char#= gotocmd_print6
    if TokenType#=DELIMIT then if TokenText$=':' goto cmd_print6

      // データの表示
      clear_value
      eval_expression

      // 文字列型データの表示
      value_type typ#=
      if typ#=STRING then get_string ss#= prints ss#, free

      // 数値型データの表示
      if typ#=NUMBER then get_number printd

      check_value
      if TokenType#=EOL then NULL, last_char#= gotocmd_print6
      if TokenType#<>DELIMIT then "Syntax Error", assertError
      TokenText$, last_char#=

      // セパレータが':'の場合
      if last_char#=':' goto cmd_print6

      // セパレータが','の場合
      if last_char#<>',' goto cmd_print5
        ',', putchar  // カンマを出力
        getToken
        goto cmd_print4

      // セパレータが';'の場合
cmd_print5:
      if last_char#<>';' then "Syntax Error", assertError
        getToken
        goto cmd_print4

cmd_print6:
    if last_char#<>';' then  nl
    DONE, end

// STOPコマンド
cmd_stop:
  1, BreakFlg#=
  DONE, end

// contコマンド
cmd_cont:

// "cmd cont:", prints nl

  BreakProg#, BreakToken#, exec_basic2
  DONE, end

// runコマンド
cmd_run:

// "cmd run:", prints nl

  cmd_clear               // 変数をクリア
  ForStack#,      ForStackP#=      // FOR-NEXT用スタックをクリア
  GosubStack#, GosubStackP#=  // GOSUB-RETURN用スタックをクリア
  TopProg#, CurrentProg#=
  if CurrentProg#=NULL then TERMINATE, end
  CurrentProg#, ->Program.text# TokenP#=
  getToken
  DONE, end

// 代入文
cmd_let:
 long vtyp#,lvar#

// "cmd let:", prints nl

  if TokenType#<>VARIABLE then DONE, end
  
//   "var name=", prints TokenText, prints nl
  
    TokenText, 0, get_variable_value lvar#= pop vtyp#=
    "=", checkToken
    eval_expression
    value_type tt#=

//   "variable type=", prints vtyp#, printd nl
//   "value type=", prints tt#, printd nl

    if tt#<>vtyp# then "Type Mismatch", assertError
    if vtyp#=NUMBER then get_number (lvar)#=
    if vtyp#=STRING   then (lvar)#, free get_string (lvar)#=

// "cmd let end:", prints nl

    DONE, end

// saveコマンド
cmd_save:

// "cmd save:", prints  TokenText, prints nl

  char wfp$(FILE_SIZE)
  if TokenType#<>STRING then "Syntax Error", assertError
  TokenText, wfp, wopen tt#=
  if tt#=ERROR then "can not save", assertError
  TopProg#, pp#=
cmd_save1:
  if pp#=NULL goto cmd_save2
  pp#, ->Program.text# wfp, fprints wfp, fnl
  pp#, ->Program.next# pp#=
  goto cmd_save1
cmd_save2:
  wfp, wclose
  TERMINATE, end

// listコマンド
cmd_list:

// "cmd list:", prints nl

  long list_st#,list_ed#
  0, list_st#= 0x7fffffff, list_ed#=
  
  if TokenType#=NUMBER then get_number list_st#= getToken
  if TokenText$=',' then  getToken
  if TokenText$='-' then  getToken
  if TokenType#=NUMBER then get_number list_ed#= getToken
  TopProg#, pp#=
cmd_list1:
  if pp#=NULL goto cmd_list3
     pp#, ->Program.lineno# tt#=
     if tt#<list_st# goto cmd_list2
     if tt#>list_ed# goto cmd_list2
       tt#, printd " ", prints  pp#, ->Program.text# prints nl
cmd_list2:
     pp#, ->Program.next# pp#=
     goto cmd_list1
cmd_list3:
    TERMINATE, end


// loadコマンド
cmd_load:

// "cmd load:", prints nl

  if TokenType#<>STRING then "Syntax Error", assertError
  TokenText, 1, load_basic
  TERMINATE, end

// QUITコマンド
cmd_quit:

// "cmd quit:", prints nl

  QUIT, end

// ENDコマンド
cmd_end:

// "cmd end:", prints nl

  TERMINATE, end

// NEWコマンド
cmd_new:

// "cmd new:", prints nl

  clear_program 
  cmd_clear
  TERMINATE, end

// clsコマンド
cmd_cls:

// "cmd cls:", prints nl

  cls
  getToken
  DONE, end

// editコマンド
cmd_edit:

// "cmd edit:", prints nl
 start_editor
 TERMINATE, end

// psetコマンド
cmd_pset:
  "(", checkToken
  clear_value
  eval_expression
  get_number xx#=
  ",", checkToken
  clear_value
  eval_expression
  get_number yy#=
  ")", checkToken
  if TokenText$<>',' goto cmd_pset1
  getToken
  clear_value
  eval_expression tt#=
  tt#, set_color
cmd_pset1:
   xx#, yy#, xdraw_point
   DONE, end

// lineコマンド
cmd_line:
  long draw_x1#,draw_y1#,draw_x2#,draw_y2#

  // 開始座標を指定する場合
  if TokenText$<>'(' goto cmd_line1
    getToken
    clear_value
    eval_expression
    get_number draw_x1#=
    ",", checkToken
    clear_value
    eval_expression
    get_number draw_y1#=
    ")", checkToken

  // 開始座標を指定しないときはここから始める
cmd_line1:
  "-", checkToken
  "(", checkToken
  clear_value
  eval_expression
  get_number draw_x2#=
  ",", checkToken
  clear_value
  eval_expression
  get_number draw_y2#=
  ")", checkToken
  if TokenText$<>',' goto cmd_line2
    getToken
    clear_value
    eval_expression tt#=
    tt#, set_color

cmd_line2:
  draw_x1#, draw_y1#, draw_x2#, draw_y2#, xdraw_line
  DONE, end

// boxコマンド
cmd_box:

  // 開始座標を指定する場合
  if TokenText$<>'(' goto cmd_box1
    getToken
    clear_value
    eval_expression
    get_number draw_x1#=
    ",", checkToken
    clear_value
    eval_expression
    get_number draw_y1#=
    ")", checkToken

  // 開始座標を指定しないときはここから始める
cmd_box1:
  "-", checkToken
  "(", checkToken
  clear_value
  eval_expression
  get_number draw_x2#=
  ",", checkToken
  clear_value
  eval_expression
  get_number draw_y2#=
  ")", checkToken
  if TokenText$<>',' goto cmd_box2
    getToken
    clear_value
    eval_expression tt#=
    tt#, set_color

cmd_box2:
  draw_x1#, draw_y1#, draw_x2#, draw_y2#, xdraw_rect
  DONE, end

// boxfコマンド
cmd_boxf:

  // 開始座標を指定する場合
  if TokenText$<>'(' goto cmd_boxf1
    getToken
    clear_value
    eval_expression
    get_number draw_x1#=
    ",", checkToken
    clear_value
    eval_expression
    get_number draw_y1#=
    ")", checkToken

  // 開始座標を指定しないときはここから始める
cmd_boxf1:
  "-", checkToken
  "(", checkToken
  clear_value
  eval_expression
  get_number draw_x2#=
  ",", checkToken
  clear_value
  eval_expression
  get_number draw_y2#=
  ")", checkToken
  if TokenText$<>',' goto cmd_boxf2
    getToken
    clear_value
    eval_expression tt#=
    tt#, set_color

cmd_boxf2:
  draw_x1#, draw_y1#, draw_x2#, draw_y2#, xfill_rect
  DONE, end
  end

// circleコマンド
cmd_circle:

  // 開始座標を指定する場合
  if TokenText$<>'(' goto cmd_circle1
    getToken
    clear_value
    eval_expression
    get_number draw_x1#=
    ",", checkToken
    clear_value
    eval_expression
    get_number draw_y1#=
    ")", checkToken

  // 開始座標を指定しないときはここから始める
cmd_circle1:
  "-", checkToken
  "(", checkToken
  clear_value
  eval_expression
  get_number draw_x2#=
  ",", checkToken
  clear_value
  eval_expression
  get_number draw_y2#=
  ")", checkToken
  if TokenText$<>',' goto cmd_circle2
    getToken
    clear_value
    eval_expression tt#=
    tt#, set_color

cmd_circle2:
  draw_x1#, draw_y1#, draw_x2#, draw_y2#, xdraw_circle
  DONE, end
  end


// circlefコマンド
cmd_circlef:

  // 開始座標を指定する場合
  if TokenText$<>'(' goto cmd_circlef1
    getToken
    clear_value
    eval_expression
    get_number draw_x1#=
    ",", checkToken
    clear_value
    eval_expression
    get_number draw_y1#=
    ")", checkToken

  // 開始座標を指定しないときはここから始める
cmd_circlef1:
  "-", checkToken
  "(", checkToken
  clear_value
  eval_expression
  get_number draw_x2#=
  ",", checkToken
  clear_value
  eval_expression
  get_number draw_y2#=
  ")", checkToken
  if TokenText$<>',' goto cmd_circlef2
    getToken
    clear_value
    eval_expression tt#=
    tt#, set_color

cmd_circlef2:
  draw_x1#, draw_y1#, draw_x2#, draw_y2#, fill_circle
  DONE, end
  end

// imageコマンド
cmd_image:

  "(", checkToken
  clear_value
  eval_expression
  get_number draw_x1#=
  ",", checkToken
  clear_value
  eval_expression
  get_number draw_y1#=
  ")", checkToken
  ",", checkToken
  clear_value
  eval_expression
  get_string ss#=
  ss#, sss, strcpy
  ss#, free
  sss, load_image tt#=
  if tt#=NULL then DONE, end
  draw_x1#, draw_y1#, tt#, xdraw_image
  DONE, end

// execコマンド
cmd_exec:

  clear_value
  eval_expression
  get_string ss#=
  ss#, sss, strcpy
  ss#, free
  sss, exec_command
  DONE, end

// locateコマンド
cmd_locate:
  clear_value
  eval_expression
  get_number xx#=
  ",", checkToken
  clear_value
  eval_expression
  get_number yy#=
  xx#, yy#, locate
  DONE, end

// colorコマンド
cmd_color:
  clear_value
  eval_expression
  get_number tt#=
  tt#, xcolor#=
  DONE, end

// len関数
func_len:

// "func len:", prints nl

  getToken
  "(", checkToken
  eval_expression
  ")", checkToken
  get_string ss#= strlen put_number
  ss#, free
  0, end

// val関数
func_val:

// "func val:", prints nl

  getToken
  "(", checkToken
  eval_expression
  ")", checkToken
  get_string ss#= xval put_number
  ss#, free
  0, end

// str$関数
func_strs:

// "func strs:", prints nl

  getToken
  "(", checkToken
  eval_expression
  ")", checkToken
  get_number 10, itoa put_string
  0, end



// left$関数
func_lefts:

// "func lefts:", prints nl

  getToken
  "(", checkToken
  eval_expression
  ",", checkToken
  eval_expression
  ")", checkToken
  get_number kk#=
  get_string ss0#= strlen ll#=
  0, ii#=
func_lefts1:
  if ii#>=kk# goto func_lefts2
  if ii#>=ll#   goto func_lefts2
  (ss0)$(ii#), sss$(ii#)=
  ii#++
  goto func_lefts1
func_lefts2:
  NULL, sss$(ii#)=
  sss, put_string
  ss0#, free
  0, end


// mid$関数
func_mids:
  long ss0#
  
// "func mids:", prints nl 

  getToken
  "(", checkToken
  eval_expression
  ",", checkToken
  eval_expression
  if TokenText$=','   then  getToken eval_expression gotofunc_midsx
  MAX_STR_LENGTH, put_number
func_midsx:
  ")", checkToken
  get_number jj#=
  get_number 1, - ii#=
  get_string ss0#= strlen ll#=
  jj#, ii#, + jj#=
  0, kk#=
  
// "string=", prints ss0#, prints nl  
  
func_mids1:
  if ii#>=jj# goto func_mids2
  if ii#>=ll# goto func_mids2
  (ss0)$(ii#), sss$(kk#)=
  ii#++
  kk#++
  goto   func_mids1
func_mids2:
  NULL, sss$(kk#)=
  sss, put_string
  ss0#, free
  0, end

// asc関数
func_asc:

// "func asc:", prints nl

  getToken
  "(", checkToken
  eval_expression
  ")", checkToken
  get_string ss#=
  (ss)$, put_number
  ss#, free
  0, end

// right$関数/
func_rights:

// "func rights:", prints nl

  getToken
  "(", checkToken
  eval_expression
  ",", checkToken
  eval_expression
  ")", checkToken
  get_number ii#=
 get_string ss0#= strlen ll#=
  ll#, ii#, - ii#=
  if ii#<0 then 0, ii#=
  0, kk#=
func_rights1:
  if ii#>=ll# goto func_rights2
  (ss0)$(ii#), sss$(kk#)=
  ii#++
  kk#++
  goto func_rights1
func_rights2:
  NULL, sss$(kk#)=
  sss, put_string
  ss0#, free
  0, end

// chr$関数
func_chrs:
 char ccc$(2)

// "func chrs:", prints nl

  getToken
  "(", checkToken
  eval_expression
  ")", checkToken
  get_number ccc$(0)=
  NULL, ccc$(1)=
  ccc, put_string
  0, end

// abs関数
func_abs:

// "func abs:", prints nl

  getToken
  "(", checkToken
  eval_expression
  ")", checkToken
  get_number tt#=
  if tt#<0 then  0, tt#, - tt#=
  tt#, put_number
  0, end

// input$関数
func_inputs:

// "func inputs:", prints nl 

  getToken
  "(", checkToken
  eval_expression


  // ファイルから指定文字数入力
  if TokenText$<>',' goto func_inputs
    getToken
    if TokenText$='#' then getToken
    eval_expression
    ")", checkToken
    get_number kk#=
    if kk#<0 then "Out of range", assertError
    if kk#>=MAX_FILES then "Out of range", assertError
    kk#, FILE_SIZE, * Xfp, + fp_adr#=
    if (fp_adr)#(FILE_FP/8)=NULL then "File is not open", assertError
    get_number nn#=
    nn#, sss, fp_adr#, _read tt#=
    if tt#=0 then EOF_STRING, put_string 0, end
    NULL, sss$(tt#)=
    sss, put_string
    0, end

  // コンソールから指定文字数入力
  func_inputs1:
    ")", checkToken
    get_number nn#=
    0, ii#=
    func_inputs2:
      if ii#>=nn# goto func_inputs3
      getch sss$(ii#)= tt#=
      if tt#>=' ' then ii#++
      goto func_inputs2
    func_inputs3:
    NULL, sss$(ii#)=
    sss, put_string
    0, end


// point関数
func_point:

  getToken
  "(", checkToken
  eval_expression
  ",", checkToken
  eval_expression
  ")", checkToken
  get_number yy#=
  get_number xx#=
  xx#, yy#, xget_point  tt#=
  tt#, put_number
  DONE, end

// inkey＄関数
func_inkeys:

// "func inkey:", prints nl

  char inkey_str$(8)
  getToken
  inkey inkey_str$=
  NULL, inkey_str+1$=
  inkey_str, put_string
  0, end


// =  の確認
eval_eq:

//  "eval eq:", prints nl

  get_number tt#=
  if tt#=0 then 1, put_number 0, end
  0, put_number 0, end

// <> の確認
eval_neq:

//  "eval neq:", prints nl

  get_number tt#=
  if tt#<>0 then 1, put_number 0, end
  0, put_number 0, end

// <  の確認
eval_lt:

// "eval lt:", prints nl

  get_number tt#=
  if tt#<0 then 1, put_number 0, end
  0, put_number 0, end

// <= の確認
eval_le:

//  "eval le:", prints nl

  get_number tt#=
  if tt#<=0 then 1, put_number 0, end
  0, put_number 0, end

// >  の確認
eval_gt:

//  "eval gt:", prints nl

  get_number tt#=
  if tt#>0 then 1, put_number 0, end
  0, put_number 0, end

.// >= の確認
eval_ge:

//  "eval ge:", prints nl

  get_number tt#=
  if tt#>=0 then 1, put_number 0, end
  0, put_number 0, end

// 比較演算
eval_cmp:

//  "eval cmp:", prints nl


  // 文字列の場合
  value_type tt#=
  if  tt#<>STRING goto eval_cmp1
    get_string s1#=
    get_string s2#=
    s1#, s2#, strcmp put_number
    s1#, free
    s2#, free
    0, end

  // 数値の場合
  eval_cmp1:
    get_number d1#=
    get_number d2#=
    d2#, d1#, - put_number
    0, end

// 論理式 AND演算
eval_and:

//  "eval and:", prints nl

  get_number ss#=
  get_number tt#=
  tt#, ss#, and
  put_number
  0, end

// 論理式 OR 演算
eval_or:

//  "eval or:", prints nl

  get_number ss#=
  get_number tt#=
  tt#, ss#, or
  put_number
  0, end

// べき乗演算
eval_power:

//  "eval power:", prints nl

  get_number ss#=
  get_number tt#=
  tt#, ss#, power
  put_number
  0, end


power:
  ss#= pop tt#=
  if ss#<=0 then 1, end
  1, xx#=
  for mm#=1 to ss#
    xx#, tt#, * xx#=
  next mm#
  xx#, end

// 除算の余り
eval_mod:

//  "eval mod:", prints nl

  get_number ss#=
  get_number tt#=
  if ss#=0 then "division by zero", assertError
  tt#, ss#, mod
  put_number
  0, end

// 除算演算
eval_div:

//  "eval div:", prints nl

  get_number ss#=
  get_number tt#=
  if ss#=0 then "division by zero", assertError
  tt#, ss#, /
  put_number
  0, end

// 乗算演算
eval_mul:

//  "eval mul:", prints nl

  get_number ss#=
  get_number tt#=
  tt#, ss#, *
  put_number
  0, end


// 減算演算
eval_sub:

// "eval sub:", prints nl

  get_number ss#=
  get_number tt#=
  tt#, ss#, -
  put_number
  0, end



// 加算演算
eval_add:

// "eval add:", prints nl

  get_number ss#=
  get_number tt#=
  tt#, ss#, +
  put_number
  0, end


// 文字列連結演算
eval_concat:

//  "eval concat:", prints nl

   MAX_STR_LENGTH*2+1, malloc s0#=
  get_string s2#=
  s2#, sss, strcpy
  s2#, free             // ここでs2をコピーして開放しておかないと、次の行でエラーが起きたときに開放されないことになる
  get_string s1#=  // ここでtype-mismatchエラーが起きる可能性がある
  s1#, s0#, strcpy
  s1#, free
  sss, s0#, strcat
  s0#, strlen tt#=
  if tt#>MAX_STR_LENGTH then s0#, free "string is too long", assertError
  s0#, put_string
  0, end

// 原子の処理
eval_atom:
  long sign#,typ#,val#
  0, sign#=

// "eval atom:", prints nl

  // 原子の前に＋がついている場合
  if TokenText$='+' then getToken  1, sign#=

  // 原子の前に-がついている場合
  if TokenText$='-' then getToken  -1, sign#=

  // (式)は原子である
  if TokenText$<>'('  goto eval_atom2
    getToken
    sign#, PUSH
    eval_expression
    POP sign#=
    ")", checkToken
    value_type tt#=
    if tt#<>STRING goto eval_atom1
    if sign#<>0 then "Type Mismatch", assertError
    
//    "eval atom(string permanent) end:", prints nl
    
    0, end
    eval_atom1:
    if sign#=-1 then  get_number tt#= 0, tt#, - put_number
    
//    "eval atom(numeric permanent) end:", prints nl
    
    0, end

  // 数値は原子である
  eval_atom2:
  if TokenType#<>NUMBER goto eval_atom3
    TokenValue#, put_number
    getToken
    if sign#=-1 then  get_number tt#= 0, tt#, - put_number
    
//    "eval atom(number) end:", prints nl
    
    0, end

  // 文字列は原子である
  eval_atom3:
  if TokenType#<>STRING goto eval_atom4
    TokenText, put_string
    getToken
    if sign#<>0 then "Type Mismatch", assertError
    
//    "eval atom(string) end:", prints nl
    
    0, end

  // 関数は原子である
  eval_atom4:
  if TokenType#<>FUNCTION goto eval_atom5
    TokenCode#, _Function.SIZE, * Function, + ->@_Function.func
    value_type tt#=
    if tt#<>STRING goto eval_atom4_1
    if sign#<>0 then "Type Mismatch", assertError
    
//    "eval atom(string function) end:", prints nl
    
    0, end
    eval_atom4_1:
    if sign#=-1 then  get_number tt#= 0, tt#, - put_number
    
//    "eval atom(numeric function) end:", prints nl
    
    0, end

  // 変数は原子である
  eval_atom5:
  if TokenType#<>VARIABLE goto eval_atom6

//    "variable:", prints nl
  
    TokenText, 1, get_variable_value val#= pop typ#=
    if typ#<>STRING goto eval_atom5_1
    (val)#, put_string
    if sign#<>0 then "Type Mismatch",  assertError
    
//    "eval atom(string variable) end:", prints nl
    
    0, end
    eval_atom5_1:
    (val)#, put_number
    if sign#=-1 then  get_number tt#= 0, tt#, - put_number
    
//    "eval atom(numeric variable) end:", prints nl
    
    0, end

  eval_atom6:
    
//    "eval atom(other) end:", prints nl
    
    0, end



// 因子の処理
eval_factor:

// "eval factor:", prints nl

  // 原子を解析
  eval_atom

  // べき乗算は数値型にのみ適用される
  value_type tt#=
  if tt#<>NUMBER then  0, end

eval_factor1:

      // 因子は原子^原子
      if TokenText$='^' then getToken eval_atom eval_power gotoeval_factor1
// "eval factor end:", prints nl
      0, end



// 項の処理
eval_term:

// "eval term:", prints nl

  // 因子を解析
  eval_factor

  // 乗除算は数値型にのみ適用される
  value_type tt#=
  if tt#<>NUMBER  then  0, end

eval_term1:

      // 項は因子*因子
      if TokenText$='*' then getToken eval_factor eval_mul gotoeval_term1

      // 項は因子/因子
      if TokenText$='/' then getToken eval_factor eval_div gotoeval_term1

      // 項は因子 mod 因子
      TokenText, "mod", strcmp tt#=
      if tt#=0 then getToken eval_factor eval_mod gotoeval_term1

// "eval term end:", prints nl
      0, end

// 算術式の処理
eval_aexpression:

// "eval aexpression:", prints nl

  // 項を解析
  eval_term
  value_type tt#=
  if tt#<>STRING goto eval_aexpression2

  // 文字列型の場合
  eval_aexpression1:

      // 式は項+項
      if TokenText$='+' then getToken eval_term eval_concat gotoeval_aexpression1

// "eval aexpression end(string):", prints nl
      0, end

  // 数値型の場合
  eval_aexpression2:
  
// "eval aexpression2:", prints nl
//  "TokenText=", prints TokenText, prints nl 
  
      // 式は項+項
      if TokenText$='+' then getToken eval_term eval_add gotoeval_aexpression2

      // 式は項-項
      if TokenText$='-' then getToken eval_term eval_sub gotoeval_aexpression2

// "eval aexpression end(number):", prints nl
      0, end

// 関係式の処理
eval_relation:

//  "eval relation:", prints nl

  // 式を解析
  eval_aexpression
  
eval_relation1:

    // 論理因子は 式>=式
    TokenText, ">=", strcmp tt#=
    if tt#<>0 goto eval_relation2
      getToken
      eval_aexpression
      eval_cmp
      eval_ge
      goto eval_relation1

    // 論理因子は 式>式
eval_relation2:
    TokenText, ">", strcmp tt#=
    if tt#<>0 goto eval_relation3
      getToken
      eval_aexpression
      eval_cmp
      eval_gt
      goto eval_relation1

    // 論理因子は 式<=式
eval_relation3:
    TokenText, "<=", strcmp tt#=
    if tt#<>0 goto eval_relation4
      getToken
      eval_aexpression
      eval_cmp
      eval_le
      goto eval_relation1

    // 論理因子は 式<式
eval_relation4:
    TokenText, "<", strcmp tt#=
    if tt#<>0 goto eval_relation5
      getToken
      eval_aexpression
      eval_cmp
      eval_lt
      goto eval_relation1

    // 論理因子は 式<>式
eval_relation5:
    TokenText, "<>", strcmp tt#=
    if tt#<>0 goto eval_relation6
      getToken
      eval_aexpression
      eval_cmp
      eval_neq
      goto eval_relation1

    // 論理因子は 式=式
eval_relation6:
    TokenText, "=", strcmp tt#=
    if tt#<>0 goto eval_relation7
      getToken
      eval_aexpression
      eval_cmp
      eval_eq
      goto eval_relation1

    // 上記以外ならば終了
eval_relation7:
//  "eval relation end:", prints nl
    0, end



// 論理項の処理
eval_lterm:

// "eval lterm:", prints nl

  // 論理因子を解析
  eval_relation
eval_lterm1:

  // and以外ならば終了
  TokenText, "and", strcmp tt#=
  if tt#<>0 then  0, end

  // 論理項は論理因子AND論理因子AND_215280110.
  getToken
  eval_relation
  eval_and
  goto eval_lterm1

// 式の処理
eval_expression:
  long s0#,s1#,s2#,d1#,d2#
  char sss$(MAX_STR_LENGTH+1)

// "eval expression:", prints nl

  // 論理項を解析
  eval_lterm
eval_expression1:

  // OR以外ならば終了
  TokenText, "or", strcmp tt#=
  if tt#<>0 then  0, end 

  // 論理式は論理項OR論理項OR_215280110.
  getToken
  eval_lterm
  eval_or
  goto eval_expression1


// 文字列をスタックから取りこむ
get_string:
  value_type tt#=
  
//  "get string:", prints nl
  
  if tt#<>STRING then "Type Mismatch", assertError
  CalcStackP#, Value.SIZE, - CalcStackP#=
  CalcStackP#, ->Value.data#  tt#=
  
  
//  "get string:", prints tt#, prints nl
  
  
  tt#, end

// 数値をスタックから取りこむ
get_number:
  value_type tt#=
  
//  "get number:", prints nl
  
  if tt#<>NUMBER then "Type Mismatch", assertError
  CalcStackP#, Value.SIZE, - CalcStackP#=
  CalcStackP#, ->Value.data# tt#=
  
//  "value=", prints tt#, printd nl
  
  tt#, end

// 文字列をスタックに置く
put_string:
  str#= strlen 1, + malloc ss#=
  
//  "put string:", prints str#, prints nl
  
  str#, ss#, strcpy
  STRING, CalcStackP#, ->Value.type#=
  ss#, CalcStackP#, ->Value.data#=
  CalcStackP#, Value.SIZE, + CalcStackP#=
  end
 

// 数値をスタックに置く
put_number:
  long num#
  num#=
  
//  "put number:", prints num#, printd nl 
  
  NUMBER, CalcStackP#, ->Value.type#=
  num#, CalcStackP#, ->Value.data#=
  CalcStackP#, Value.SIZE, + CalcStackP#=
 end
 

// 現在の計算スタックの値の型を返す、スタックに値が入っていない場合は0を返す
value_type:
 
  if CalcStackP#=CalcStack# then 0, end
  CalcStackP#, Value.SIZE, - tt#=
  tt#, ->Value.type# end

// 現在の計算スタックをチェックして整合がとれていなかったらエラーを発生させる
check_value:
  if CalcStackP#<>CalcStack# then "ileagal expression", assertError
  end

// 計算用スタックを初期化する
clear_value:


// "clear value:", prints nl

  // 計算スタックに入っている値を全て取り出す
  if CalcStackP#<=CalcStack# goto clear_value1
  CalcStackP#, Value.SIZE, - CalcStackP#=
  CalcStackP#, ->Value.type# tt#=
  if tt#=STRING then CalcStackP#, ->Value.data# free
  goto clear_value
clear_value1:
  CalcStack#, CalcStackP#=
  end

// 変数の値を格納してあるアドレスを得る
get_variable_value:
  long vii#,force_error#,xvname#,index#,dims#,xdim#,xvar#,xtype#
  force_error#= pop xvname#=
  
//  "get variable value:", prints nl
//  "var name=", prints xvname#, prints nl
  
  xvname#, force_error#, _variable xvar#=
  xvname#, var_type xtype#=

  // 単純変数の場合
  xvar#, ->Variable.dimension# dims#=
//  if dims#=0 then "get variable value end:", prints nl
  if dims#=0 then  getToken var#, ->Variable.value# ->Value.data xtype#, swap end

  // 配列変数の場合
  getToken
  "(", checkToken
  eval_expression
  get_number index#=
  xvar#, ->Variable.dim xdim#=
  if index#<0 then "array range is over", assertError
  if index#>(xdim)#(0) then  "array range is over", assertError
  1, vii#=
get_variable_value1:
  if vii#>=dims# goto get_variable_value2
  ",",  checkToken
  eval_expression get_number xx#=
  if xx#<0 then "array range is over", assertError
  if xx#>(xdim)#(vii#) then "array range is over", assertError
  index#, (xdim)#(vii#), * xx#, + index#=
  vii#++
  goto get_variable_value1
get_variable_value2:
  ")",  checkToken
  index#, 8, * index#=

//  "get variable value end:", prints nl

  xvar#, ->Variable.value# ->Value.data#  index#, + xtype#, swap end

// 変数名から変数記憶用メモリへのポインタを得る
get_variable:
  var_name#=

// "get variable:", prints nl
// "var name=", prints var_name#, prints nl

  // 変数を探す
  TopVar#, var#=
get_variable1:
  if var#=NULL goto get_variable2
  var#, ->Variable.name# var_name#, strcmp tt#=
  if tt#=0 then  var#, end
  var#, ->Variable.next# var#=
  goto get_variable1

  // 変数が存在しないときはNULLを返す
get_variable2:

// "variable=null", prints nl

  NULL, end

// 変数名から変数を得る
// 変数が存在しないときはエラーを出すように指定されている場合は
// エラーを出して、そうでない場合は新しく変数を作る
_variable:
  long var_name#
  force_error#= pop var_name#= get_variable var#=

// "_variable:", prints nl

  if var#<>NULL then var#, end
  if force_error#<>0 then "variable not found", assertError

  // 変数が見つからなかったら、新しく確保した変数記憶メモリへのポインタを返す 
  
//  "new variable:", prints nl
//  "var name=", prints var_name#, prints nl
  
  
  Variable.SIZE, malloc var#=
  var_name#, strlen 1, + malloc var#, ->Variable.name#=
  var_name#, var#, ->Variable.name# strcpy
  Value.SIZE, malloc var#, ->Variable.value#=
  0, var#, ->Variable.dimension#=

  // 文字列変数の場合は空の文字列で初期化、数値変数の場合は0で初期化する
  var_name#, var_type tt#=
  if tt#<>STRING goto _variable1
  
//  "type string:", prints nl
  
    STRING, var#, ->Variable.value# ->Value.type#=
    ALIGNMENT, malloc tt#= var#, ->Variable.value# ->Value.data#=
    "", tt#, strcpy
     goto _variable2

  // 数値の場合
_variable1:
  
//  "type number:", prints nl
  
   NUMBER, var#, ->Variable.value# ->Value.type#=
   0, var#, ->Variable.value# ->Value.data#=

  // 変数リストに登録する
_variable2:

//  "register variable list:", prints nl

  if TopVar#=NULL then  var#, TopVar#=
  if EndVar#<>NULL then  var#, EndVar#, ->Variable.next#=
  var#, EndVar#=
  NULL, var#, ->Variable.next#=
  var#, end

// 変数名から変数の型を得る
var_type:
  var_name#=  strlen 1, - tt#=
  if (var_name)$(tt#)='$' then STRING, end
  NUMBER, end

// 変数の全クリア
clear_variable:
  TopVar#, var#=

//  "claer variable:", prints nl

clear_variable1:
  if var#=NULL goto clear_variable5
  
    // 配列変数の場合
    var#, ->Variable.dimension# tt#=
    if tt#=0 goto clear_variable3

      // 文字列型配列の場合は各要素に格納されている文字列も消去する必要がある
      var#, ->Variable.name# tt#=
      if  tt#<>STRING goto clear_variable2
        var#, ->Variable.value# ->Value.data# str#=
        var#, ->Variable.dimension# 1, - nn#=
        1, mm#=
        var#, ->Variable.dim pp#=
        for ii#=0 to nn#
          mm#, (pp)#, * mm#=
          pp#, 8, + pp#=
        next ii#
        mm#--
        for ii#=1 to mm#
          (str)#(ii#), free
        next ii#

      // 配列を消去する
      clear_variable2:
      var#, ->Variable.value# ->Value.data# free
      goto clear_variable4

    // 単純変数の場合
    clear_variable3:

      // 文字列変数の場合は格納されている文字列も消去する必要がある
      var#, ->Variable.name# tt#=
      if  tt#=STRING then var#, ->Variable.value# ->Value.data# free

    // 変数を消去する
    clear_variable4:
    var#, vv#=
    var#, ->Variable.next# var#=
    vv#, ->Variable.name# free
    vv#, ->Variable.value# free
    vv#, free
    goto clear_variable1

  clear_variable5:
  NULL, TopVar#= EndVar#=
  end

//  スクリーンエディタ

  const LINES 24
  const COLS  64

  long   xbuf#,li#,li0#,el#
  long   etext#,etext0#,tail#,copy_p#
  long   temp1#,temp2#,temp3#,temp4#
  long   t1#,t2#,t3#,t4#,y0#
  long   xxtext#,xxli#
  long   xk#,k2#
  char   eflg$
  char   efp$(FILE_SIZE),efname$(16),sxbuf$(256)
  short disp_xbuf%(2048)

start_editor:
  cls
  "notitle.txt", efname, strcpy
  1,   li#= li0#= el#=
  100000, malloc xbuf#=
  xbuf#, etext#= tail#= copy_p#=
  0,   xx#= yy#= y0#= (xbuf)$=

  receive_prog

// コマンド（１文字）入力
get_command:
  display
   0, eflg$=
   1, ll#=

// コマンドタイプ０：数字（パラメータ）
get_command0:
   xk#, k2#=
   inkey xk#=
   if xk#=0     goto get_command0
   if xk#=k2# goto get_command0

   if xk+2$<'0' goto get_command1
   if xk+2$>'9' goto get_command1
   if eflg$=0 then 0, ll#=
   ll#, 10, * xk+2$, + '0', - ll#=
   1,  eflg$=
   goto get_command0

// コマンドタイプ１：テキストが空の時は無効
get_command1:
   if tail#=xbuf# goto get_command2
   if xk+2$='s'    then etext#, copy_p#= 
   if xk$=2      then xjump_foward  // 下矢印キー
   if xk+2$='j'     then xjump            
   if xk+2$='.'     then xjump_end
   if xk$=1      then xjump_reverse  // 上矢印キー
   if xk+2$='d'    then delete_line 
   if xk+2$='c'    then copy
   if xk+2$='m'   then modefy
   if xk+2$=';'     then etext#, xxtext#= li#, xxli#= serch
   if xk+2$=':'     then etext#, xxtext#= li#, xxli#= serch_next
   if xk+2$='w'    then write_file

// コマンドタイプ２：常に有効
get_command2:
   if xk+2$='i'    then li#, xxli#= insert
   if xk+2$='a'   then li#, xxli#= 1, ll#= jump_foward nl insert
   if xk+2$='r'   then nl erase_line  read_file
   if xk+2$='q'   goto quit
   if xk+2$='?'   then help
   goto get_command

// 指定行にジャンプ
xjump:
  jump
  li#, li0#=
  etext#, etext0#=
  end

// 後方にジャンプ
xjump_foward:
  jump_foward
  li#, li0#, - LINES-1, - xx#=
  if xx#>0 then xx#, ll#= jump0_foward
  end

// 前方にジャンプ
xjump_reverse:
  jump_reverse
  if li#<li0# then li#, li0#= etext#, etext0#=
  end

// 最終行にジャンプ
xjump_end:
 el#, li#=  li0#=
 tail#, etext#= etext0#=
 LINES/2, ll#= jump0_reverse
 end

// 指定行削除
delete_line:
  if ll#=0 then end
  etext#, temp1#= temp2#=
  li#,   temp3#=
  jump_foward
  if copy_p#<temp1# goto loop5
  if copy_p#<etext#  then xbuf#, copy_p#= gotoloop5
  copy_p#, etext#, - temp1#, + copy_p#=
  loop5:
    if etext#>=tail# goto exit5
    (etext)$, (temp1)$=
    temp1#++
    etext#++
    goto loop5
  exit5:
  0,      (temp1)$=
  temp1#, tail#=
  temp3#, li#, - el#, + el#=
  temp3#, li#=
  temp2#, etext#=
  end

// 指定行コピー
copy:
  etext#, temp1#=
  ll#,    temp2#=
  li#,   temp3#=
  loop6:
  if temp2#<=0      goto exit6
  if temp1#>=tail#  goto exit6
    copy_p#, sxbuf,  strcpy
    copy_p#, etext#= 1, ll#= jump_foward etext#, copy_p#=
    temp1#,  etext#= insert1 etext#, temp1#=
    temp2#--
    goto loop6
  exit6:
  temp3#, li#=
  end

// 現在の行を修正
modefy:
  0, LINES-1, locate erase_line 
  "STRING1? ", prints sxbuf, inputs
  etext#, sxbuf, strstr  temp1#=
  if temp1#=NULL then 0, LINES-1, locate erase_line "STRING NOT FOUND", prints getchar end
  sxbuf, strlen temp1#, + temp2#=
  etext#, temp3#=
  sxbuf,  temp4#=
  loop7:
    if temp3#>=temp1# goto exit7
    (temp3)$, (temp4)$=
    temp3#++
    temp4#++
    goto loop7
  exit7:
  0, LINES-1, locate erase_line 
  "STRING2? ", prints temp4#, inputs
  temp2#, temp4#, strcat
  1, ll#= delete_line insert1
  1, ll#= gotojump_reverse

// 文字列のサーチ
serch:
  0, LINES-1, locate erase_line 
  "STRING? ", prints sxbuf, inputs
serch1:
  etext#, sxbuf, strstr temp1#=
  if temp1#<>NULL then   li#, li0#=  etext#, etext0#= end

// 続けて文字列サーチ
serch_next:
  1, ll#= jump_foward
  if etext#<tail# goto serch1
  xxtext#, etext#=
  xxli#, li#=
  end

// ファイルに出力
write_file:
  0, LINES-1, locate erase_line 
  "FILE NAME? ", prints sxbuf, inputs
  if sxbuf$<>0 then sxbuf, efname, strcpy
  etext#, temp1#=
  li#,   temp2#=
  efname, efp, wopen t1#=
  if t1#=ERROR then "can not open ", prints efname, prints getchar end
  xbuf#, etext#=
  1,  li#=
  loop8:
    if etext#>=tail# goto exit8
    etext#, efp, fprints efp, fnl
    1, ll#= jump_foward
    goto loop8
  exit8:
  temp1#, etext#=
  temp2#, li#=
  efp, wclose
  end

// ファイルから入力
read_file:
  0, LINES-1, locate erase_line 
  "FILE NAME? ", prints sxbuf, inputs
read_file1:
  if sxbuf$<>0 then sxbuf, efname, strcpy
  efname, efp, ropen t1#=
  if t1#=ERROR goto read_error
  xbuf#, etext#=
  1,   li#=
  loop9:
    etext#, efp, finputs temp1#=
    if temp1#=EOF goto exit9
    if (etext)$=0 then " ", etext#, strcpy
    etext#, strlen etext#, + 1, + etext#=
    li#++
    goto loop9
  exit9:
  efp, rclose
  0, (etext)$=
  li#,   el#=
  etext#, tail#=
  xbuf#, etext#= etext0#=
  1, li#= li0#=
  end

// 読み込みエラー
read_error:
  0, LINES-1, locate erase_line
  "can not open ", prints efname, prints getchar
   end


// テキスト挿入
insert:
  erase_line
  "> ", prints sxbuf, inputs
  sxbuf, ".", strcmp temp1#=
  if sxbuf$=NULL then " ", sxbuf, strcpy
  if temp1#=0 then xxli#, ll#= xjump end
  insert1
  goto insert

// １行挿入
insert1:
  li#++
  el#++
  sxbuf, strlen 1, + t1#=
  etext#, t2#=  + etext#=
  t1#, tail#, t3#=  + tail#= t4#=
  if copy_p#>=t2# then copy_p#, t1#, + copy_p#=
  loop10:
    (t3)$, (t4)$=
    t3#--
    t4#--
  if t3#>=t2# goto loop10
  sxbuf, t2#, strcpy
  end

// 終わり
quit:
  send_prog
  xbuf#, free
  cls
  end

// ヘルプ
help:
  cls
  "(r) read (w) write (q) quit", prints nl
  "(a) append (i) insert (.) tail", prints nl
  "(j) jump (BS) up (Enter) down", prints nl
  "(d) delete (m) modefy (?) line no", prints nl
 getchar
 end
 

// スクリーン表示
display:
   long tx0#,ds#
   etext0#, tx0#=
   disp_xbuf, ds#=
   1, ii#=
   1, jj#=
display1:
   if  tx0#>=tail# goto display4
   if (tx0)$=NULL then tx0#++ gotodisplay2
   (tx0)$, (ds)%=
   tx0#++
   ds#, 2, + ds#=
   jj#++
   if jj#<=COLS goto display1
   goto display3
display2:
   ' ', (ds)%=
   ds#, 2, + ds#=
   jj#++
   if jj#<=COLS goto display2
display3:
   CR, (ds)%=
   ds#, 2, + ds#=
   LF, (ds)%=
   ds#, 2, + ds#=
   1, jj#=
   ii#++
   if ii#<=LINES goto display1
   goto set_locate

display4:
   '~', (ds)%=
   ds#, 2, + ds#=
   jj#++
display5:
   ' ', (ds)%=
   ds#, 2, + ds#=
   jj#++
   if jj#<=COLS goto display5
display6:
   CR, (ds)%=
   ds#, 2, + ds#=
   LF, (ds)%=
   ds#, 2, + ds#=
   1, jj#=
   ii#++
   if ii#<=LINES goto display4

set_locate:
   0, cursor
   NULL, (ds)%=
   0, 0, locate
   disp_xbuf, wputs
   0, LINES, locate erase_line li#, printd
   li#, li0#, - kk#=
   0, kk#, locate
   1, cursor
  end

// 指定行にジャンプ
jump_foward:
   li#, ll#, + ll#=
   goto jump_foward1

// 後ろにジャンプ
jump:
  xbuf#, etext#=
  1, li#=
  jump_foward1:
    if li#>=ll# then end
    jump_foward2:
      if etext#>=tail# then el#, li#= tail#, etext#= end
      etext#++
    if (etext)$<>NULL goto jump_foward2
    etext#++
    li#++
  goto jump_foward1

// 前にジャンプ
jump_reverse:
  li#,   ll#, - ll#=
  jump_reverse1:
    if li#<=ll# then end
    etext#--
    jump_reverse2:
      if etext#<=xbuf# then 1, li#= xbuf#, etext#= end
      etext#--
    if (etext)$<>NULL goto jump_reverse2
    etext#++
    li#--
  goto jump_reverse1

// 後ろにジャンプ
jump0_foward:
  li0#, ll#, + ll#=
  goto jump01

// 指定行にジャンプ
jump0:
  xbuf#, etext0#=
  1,   li0#=
  jump01:
    if  li0#>=ll# then end
    jump02:
      if etext0#>=tail# then end
      etext0#++
    if (etext0)$<>NULL   goto jump02
    etext0#++
    li0#++
  goto jump01

// 前にジャンプ
jump0_reverse:
  li0#,   ll#, - ll#=
  jump0_reverse1:
    if li0#<=ll# then end
    etext0#--
    jump0_reverse2:
      if etext0#<=xbuf# then 1, li#= xbuf#, etext#= end
      etext0#--
    if (etext0)$<>NULL goto jump0_reverse2
    etext0#++
    li0#--
  goto jump0_reverse1

// 一行画面消去
erase_line:
  13, putch
  for nn#=1 to COLS
    ' ', putch
  next nn#
  13, putch
  end

// プログラムを受け取る
receive_prog:
  TopProg#, pp#=
  xbuf#, etext#=
  1,   li#=
receive_prog1:
  if pp#=NULL goto receive_prog2
  pp#, ->Program.text# etext#, strcpy
  if (etext)$=0 then  " ", etext#, strcpy
  etext#, strlen etext#, + 1, + etext#=
  li#++
  pp#, ->Program.next# pp#=
  goto receive_prog1
receive_prog2:
  NULL, (etext)$=
  li#,   el#=
  etext#, tail#=
  xbuf#, etext#= etext0#=
  1, li#= li0#=
  end

// プログラムを送る
send_prog:
  etext#, temp1#=
  li#,   temp2#=
  xbuf#, etext#=
  1,  li#=
  cmd_new
send_prog1:
    if etext#>=tail# goto send_prog2
    etext#, append_line
    1, ll#= jump_foward
    goto send_prog1
send_prog2:
  temp1#, etext#=
  temp2#, li#=
  end


_INIT_STATES:

 end
main:
  _INIT_STATES
  goto _PSTART
_PSTART:
 _1627052314_in

 end
_1627052314_in:
// BASICを起動する
start_basic:


  char text$(MAX_TEXT_LENGTH+1)
  long status#
  char prog$(Program.SIZE)
  __stack_p#, StackSave#=
  STACK_SIZE, malloc ForStack#=
  STACK_SIZE, malloc GosubStack#=
  NULL, prog, ->Program.prev#= prog, ->Program.next#=
  
  
  0xffffff, xcolor#=
  screen_width#, xwidth#=
  screen_height#, xheight#=
  graphic_base#, bitmap#=
  
  0, prog, ->Program.lineno#=
  text, prog, ->Program.text#=
  1, RunFlg#=
  0, BreakProg#=

  // コマンドモード(パラメータ無しで起動した場合)
  argv#(1), fname#=
  if (fname)$<>NULL goto start_basic4
    cls
    "Oreore Basic ver 0.0.1", prints nl
    cmd_new
basic_entry:

      // 通常処理
        nl "READY", prints nl

        // コマンド入力ループ
start_basic1:

          // 計算スタック初期化
          clear_value

          // 1行入力
start_basic2:
          text, inputs tt#=
          if tt#<>13 then nl "? ", prints gotostart_basic2 
          if text$=NULL goto start_basic2

  0, BreakFlg#=


          // テキストだけのときはインタープリタに解析実行させる
              NULL, prog, ->Program.prev#=
              NULL, prog, ->Program.next#=
              -1, prog, ->Program.lineno#=
              -1, prog, ->Program.label#=
              text, prog, ->Program.text#=
              prog, exec_basic status#=
              if status#=QUIT goto start_basic3
              if status#<>TERMINATE then  "direct command only", assertError
              goto basic_entry

start_basic3:
        cmd_new
        "<<<BYE>>>", prints nl
        goto start_basic5

  // RUNモード(BASICファイル名をパラメータとして起動した場合)
start_basic4:
       cls
      fname#, 0, load_basic
      NULL, prog, ->Program.prev#=
      NULL, prog, ->Program.next#=
     -1, prog, ->Program.lineno#=
     -1, prog, ->Program.label#=
      "run", prog, ->Program.text#=
       prog, exec_basic
      cls
      cmd_new

// BASIC終了
start_basic5:
   ForStack#,     free
   GosubStack#, free
   end

 end
