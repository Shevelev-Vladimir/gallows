# encoding: utf-8

class ResultPrinter
  attr_accessor :version

  def initialize(game)
    @status_image = []

    counter = 0
    while counter <= game.max_errors
      file_name = File.dirname(__FILE__) + "/../image/#{counter}.txt"

      if File.exist?(file_name)
        file = File.new(file_name, "r:UTF-8")
        @status_image << file.read
        file.close
      else
        # Если файла нет, вместо соответствующей картинки будет «заглушка».
        @status_image << "\n [ изображение не найдено ] \n"
      end

      counter += 1
    end
  end

  # Очищает экран.
  def cls
    system("cls") or system("clear")
  end

  # Вывод версии программы.
  def print_version(version)
    "Игра \"Виселица\". Версия #{version}."
  end

  # Рисуем виселицу.
  def print_gallows(error)
    puts @status_image[error]
  end

  # Подготавливаем слово для вывода, в формате игры "Поле чудес".
  def get_word_for_print(hide_words, good_letters)
    result = ""

    # Тоже самое что и 48 - 50
    hide_words.map { |l| good_letters.include?(l) ? "#{letter} " : "__ "}

    for letter in hide_words do
      result += good_letters.include?(letter) ? "#{letter} " : "__ "
    end

    result
  end

  # Метод склонятор из задания 9-5.
  def inflection(number, krokodil, krokodila, krokodilov)
    return krokodilov if (11..14).include?(number % 100)

    case number % 10
    when 1 then krokodil
    when 2..4 then krokodila
    else krokodilov
    end
  end

  # Выводим информацию о ходе игры.
  def print_status(game)
    cls
    puts print_version(version)
    puts
    puts "#{get_word_for_print(game.hide_words, game.good_letters)}"
    puts "Ошибки: #{game.bad_letters.uniq.join(", ")}"

    print_gallows(game.errors)

    message =
      if game.won?
        "\nПоздравляем, вы выиграли!"
      elsif game.lost?
        "\nСожалеем, Вы проиграли." \
          "\nБыло загаданно слово: #{game.hide_words.join("")}"
      else
        "У Вас осталось #{game.errors_left} " \
          "#{inflection(game.errors_left, "попытка", "попытки", "попыток")}."
      end

    puts message
  end
end
