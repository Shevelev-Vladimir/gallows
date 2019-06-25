# encoding: utf-8

# Игра "Виселица". Версия 4.0.
VERSION = 5.0

# Решаем проблему с кодировкой на Windows.
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

# Подключаем файлы расположенный в папке, расположенной на уровень выше,
# что и запускаемая программа.
require_relative 'lib/game.rb'
require_relative 'lib/result_printer.rb'
require_relative 'lib/word_reader.rb'

# Объявляем объект класса.
word_reader = WordReader.new
# Записываем в переменную путь от ЭТОГО файла до words.txt.
words_file_name = File.dirname(__FILE__) + "/data/words.txt"
# Получаем загадываемое слово либо из командной строки,
# либо из файла со списком слов.
hide_word = word_reader.get_word(ARGV[0], words_file_name)

# Объявляем объект класса.
game = Game.new(hide_word)

# Объявляем объект класса.
printer = ResultPrinter.new(game)
printer.version = VERSION

# Основная игра.
while game.in_progress?
  printer.print_status(game)
  game.ask_next_letter
end

# Выводим результат игры.
printer.print_status(game)
