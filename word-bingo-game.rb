################################################################################
# Contens    : Word Bingo Game                                                 #
# File Name  : word-bingo-game.rb                                              #
# Written by : YUKISAKI                                                        #
# Date       : 2020/11/23                                                      #
# How to use : ruby word-bingo-game.rb                                         #
################################################################################

class WordBingoGame
  attr_reader :size               #SxSのビンゴカードのサイズSを表す数字
  attr_reader :num_of_words       #ゲーム中選ばれる単語の数N
  attr_reader :words              #ゲーム中選ばれる（入力される）単語
  attr_reader :word_bingo_card    #SxSのビンゴカード（WordBingoCardインスタンス）


  def initialize
    @size = 0
    @num_of_words = 0
    @words = []
  end

  public
  # 標準入力から数字を受け取ってインスタンス変数 @size に値を代入するメソッド
  # 入力条件3≦S≦1000に合わない場合はプログラムを終了する
  def input_size
    str = gets

    if correct_size?(str)
      @size = str.to_i
    else
      exit
    end
  end

  # 標準入力から数字を受け取ってインスタンス変数 @num_of_words に値を代入するメソッド
  # 入力条件1≦S≦2000に合わない場合はプログラムを終了する
  def input_num_of_words
    str = gets

    if correct_num_of_words?(str)
      @num_of_words = str.to_i
    else
      exit
    end
  end

  # 標準入力からN個の文字列を受け取ってインスタンス変数 @words に格納するメソッド
  def input_words
    1.upto(@num_of_words) {
      word = gets.chomp
      exit unless half_width_characters?(word)     #入力された文字列が半角英数字出ない場合はプログラムを終了
      @words << word
    }
  end

  # 標準入力からS個xS個の文字列を受け取ってインスタンス変数 @word_bingo_card にWordBingoCardインスタンスを格納するメソッド
  def set_word_bingo_card
    bc_words = input_bingo_card_words
    @word_bingo_card = WordBingoCard.new(@size, bc_words)
  end


  private
  # 引数の文字列が3から1000の数字かどうかを判定するメソッド
  def correct_size?(str)
    size = str.to_i
    if (size >= 3) && (size <= 1000)
      return true
    else
      return false
    end
  end

  # 引数の文字列が1から2000の数字かどうかを判定するメソッド
  def correct_num_of_words?(str)
    size = str.to_i
    if (size >= 1) && (size <= 2000)
      return true
    else
      return false
    end
  end

  # 引数の文字列が半角英数字かどうかを判定するメソッド
  def half_width_characters?(word)
    if /^[0-9a-zA-Z]+$/ =~ word
      return true
    else
      return false
    end
  end

  # 標準入力からS個xS個の文字列を受け取ってS行S列の二次元配列を返すメソッド
  # 文字と文字の間はスペースで区切るものとする
  def input_bingo_card_words
    lines = []

    1.upto(@size) {
      line = gets                         #標準入力から文字列を取得　例）"word1 word2 word3\n"
      words = line.chomp.split(' ')       #文字の配列に変換　例）[word1, word2, word3]
      exit unless words.size == @size     #文字数がビンゴカードのサイズSと一致しない場合はプログラムを終了
      lines << words
    }

    return lines                          #SxSの二次元配列
  end
end



class WordBingoCard
  attr_reader :size               #SxSのビンゴカードのサイズSを表す数字
  attr_reader :bingo_card_words   #ビンゴカードに書かれた単語を表す二次元配列
  attr_reader :bingo_card_marks   #ビンゴカードに付いた印を表す二次元配列

  def initialize(size, bc_words)
    @size = size
    @bingo_card_words = bc_words
    @bingo_card_marks = Array.new(size) {Array.new(size, false)}
  end

  public
  # 引数 word のビンゴカードの位置に印（true）をつけるメソッド
  def mark(word)
    0.upto(@size-1) {|i|
      j = @bingo_card_words[i].index(word)
      unless j == nil
        @bingo_card_marks[i][j] = true
        return
      end
    }
  end

  # ビンゴが成立しているか判定するメソッド
  # @return : ビンゴ成立→true, ビンゴ不成立→false
  def bingo?
    if bingo_in_rows?                           #行方向にビンゴが成立しているか
      return true
    elsif bingo_in_columns?                     #列方向にビンゴが成立しているか
      return true
    elsif bingo_diagonally_from_upper_left?     #斜め（左上から右下へ）にビンゴが成立しているか
      return true
    elsif bingo_diagonally_from_upper_right?    #斜め（右上から左下へ）にビンゴが成立しているか
      return true
    else
      return false
    end
  end


  private
  # 行方向にビンゴが成立しているか判定するメソッド
  def bingo_in_rows?
    @bingo_card_marks.each {|row|
      if row.all? {|mark| mark==true}
        return true
      end
    }
    return false
  end

  # 列方向にビンゴが成立しているか判定するメソッド
  def bingo_in_columns?
    @bingo_card_marks.transpose.each {|row|
      if row.all? {|mark| mark==true}
        return true
      end
    }
    return false
  end

  # 斜め（左上から右下へ）にビンゴが成立しているか判定するメソッド
  def bingo_diagonally_from_upper_left?
    0.upto(@size-1) {|i|
      if @bingo_card_marks[i][i] == false
        return false
      end
    }
    return true
  end

  # 斜め（右上から左下へ）にビンゴが成立しているか判定するメソッド
  def bingo_diagonally_from_upper_right?
    0.upto(@size-1) {|i|
      if @bingo_card_marks[i][@size-1-i] == false
        return false
      end
    }
    return true
  end
end



# メインプログラム
wbg = WordBingoGame.new             #WordBingoGameインスタンス生成
wbg.input_size                      #標準入力からSを入力
wbg.set_word_bingo_card             #標準入力からS個xS個の単語列を入力
wbg.input_num_of_words              #標準入力からNを入力
wbg.input_words                     #標準入力からN個の単語を入力

#N個の単語に対してビンゴカードに印をつける
wbg.words.each {|word|
  wbg.word_bingo_card.mark(word)
}

#ビンゴが成立しているかどうかを標準出力へ出力
if wbg.word_bingo_card.bingo?
  puts "yes"
else
  puts "no"
end
