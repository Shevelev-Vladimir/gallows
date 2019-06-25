# encoding: utf-8

# Игра "Виселица". Версия 4.0.
version = 4.0

# Решаем проблему с кодировкой на Windows.
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

# Подключаем файлы расположенный в той же папке что и запускаемая программа.
require_relative "./lib/game"
require_relative "./lib/result_printer"
require_relative "./lib/word_reader"

# Записали в переменную путь до запускаемого файла.
current_path = File.dirname(__FILE__)

# Записываем в переменную путь от ЭТОГО файла до words.txt.
words_file_name = current_path + "/data/words.txt"

# Объявляем объект класса.
word_reader = WordReader.new
# Получаем загадываемое слово либо из командной строки,
# либо из файла со списком слов.
hide_word = word_reader.get_word(ARGV[0], words_file_name)

# Объявляем объект класса.
game = Game.new(hide_word)

# Объявляем объект класса.
printer = ResultPrinter.new(current_path, game)
printer.print_version(version)

# Основная игра.
while game.in_progress?
  printer.print_status(game)
  puts "\nВведите следующую букву."
  user_input = STDIN.gets.downcase.chomp.to_s
  game.next_step(user_input)
end

# Выводим результат игры.
printer.print_status(game)
