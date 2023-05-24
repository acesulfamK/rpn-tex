# bison構文解析を用いたラムダ計算コンパイラ(未完成)

# 実装した文法
- frac:
- ^:
- _:
- &(cat):
- ():
- \int:


# ファイル構成
- rpn-tex: rpn記法で書かれたtexをtex数式モードに変換する。

- only-plus: bison exampleのcalc.yから間引いて、数値+数値、の形をしたコードのみ計算するようにしたもの。.gvファイルを、graphvizで見るために単純なコードにした。これを改変してstring+stringで文字列を結合するようにしたのが、plus-to-string。

- plus-to-string: only-plusを改変して、string+stringを入力したときのみこれらをcatして返すコード

- rpn: RPN(逆ポーランド記法)を処理するbison examplesのコード

- tree.c: 2分木アルゴリズム。ノードを構造体で管理している。

- lex-tutorial: flexを試す。動かない

- only-plus-header: 標準入力以外に対応させようとした。動かない。 

# 考えられる原因とデバッグ方法

yylexエラー
- 正しく形態素に区切れているか -> 文字数のカウントや、型をprintして確かめる。

構文エラー
- %varboseなどを用いてどこの入力がsyntax errorだったかを解析する
- 数値などの単純なtoken(終端記号)を持つ、同じ構造の文法規則を作り、--graphを指定してコンパイルして、.gvファイルのオートマトンを比較する。

