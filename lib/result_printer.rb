# encoding: utf-8

class ResultPrinter
  def initialize(path, game)
    @status_image = []

    counter = 0
    while counter <= game.max_errors
      file_name = path + "/image/#{counter}.txt"

      if File.exist?(file_name)
        file = File.new(file_name, "r:UTF-8")
        @status_image << file.read
        file.close
      else
        # Если файла нет, вместо соответствующей картинки будет «заглушка»
        @status_image << "\n [ изображение не найдено ] \n"
      end

      counter += 1
    end
  end

  def print_version(version)
    puts "Игра \"Виселица\". Версия #{version}."
    sleep 1
  end

  # Очищаем экран.
  def cls
    system("cls") or system("clear")
  end

  # Рисуем виселицу.
  def print_viselitsa(error)
    puts @status_image[error]
  end

  # Подготавливаем слово для вывода, в формате игры "Поле чудес".
  def get_word_for_print(hide_words, good_letters)
    result = ""

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
    when (2..4) then krokodila
    else krokodilov
    end
  end

  # Выводим информацию о ходе игры.
  def print_status(game)
    cls

    puts
    puts "#{get_word_for_print(game.hide_words, game.good_letters)}"
    puts "Ошибки: #{game.bad_letters.uniq.join(", ")}"

    print_viselitsa(game.errors)

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
