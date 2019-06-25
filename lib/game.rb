# encoding: utf-8

# Основной класс игры Game. Хранит состояние игры и предоставляет функции для
# развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.).
class Game
  # Гетеры.
  attr_reader :status, :errors, :hide_words, :good_letters, :bad_letters

  # Максимальное число ошибок.
  MAX_ERRORS = 7

  def initialize(hide_word)
    @hide_words = get_hide_words(hide_word)
    @good_letters = []
    @bad_letters = []
    @errors = 0
    @status = :in_progress # :won, :lost
  end

  def errors_left
    MAX_ERRORS - @errors
  end

  def max_errors
    MAX_ERRORS
  end

  # Метод, который возвращает загадываемое слово в виде массива строчных букв.
  def get_hide_words(hide_word)
    if hide_word.nil? || hide_word == ''
      abort 'Задано пустое слово, не о чем играть. Закрываемся.'
    else
      hide_word = hide_word.encode('UTF-8')
    end

    hide_word.downcase.split("")
  end

  # Проверяем есть ли введённая пользователем буква в загаданном слове.
  def is_good?(letter)
    @hide_words.include?(letter) ||
       letter == "е" && @hide_words.include?("ё") ||
       letter == "ё" && @hide_words.include?("е") ||
       letter == "и" && @hide_words.include?("й") ||
       letter == "й" && @hide_words.include?("и")
  end

  # добавить букву в массив
  def add_letter_to(letters, letter)
    letters << letter

    case letter
    when 'и' then letters << 'й'
    when 'й' then letters << 'и'
    when 'е' then letters << 'ё'
    when 'ё' then letters << 'е'
    end
  end

  # Отгадано ли слово?
  def solved?
    (@hide_words - @good_letters).empty?
  end

  # Ввод неправильный?
  def wrong_input?(letter)
    @good_letters.include?(letter) || @bad_letters.include?(letter) ||  \
      letter == "" || letter.size > 1
  end

  # Игра продолжается?
  def in_progress?
    @status == :in_progress
  end

  def won?
    status == :won
  end

  # Если статус lost или ошибок больше или равно MAX_ERRORS — проигрыш.
  def lost?
    status == :lost || @errors >= MAX_ERRORS
  end

  # Проверяем есть ли введённая пользователем буква в загаданном слове, \
  # а также статус игры.
  def next_step(letter)
    return if @status == :lost || @status == :won
    # Если буква введена повторно, или ничего не введено, или введено слишком много
    # символов, то ничего не делаем.
    return if wrong_input?(letter)

    # Если буква угадана то записываем в массив good_letters
    if is_good?(letter)
      add_letter_to(@good_letters, letter)

      # Проверка — угадано ли все слово целиком.
      solved? && @status = :won
    # Если в слове нет введенной буквы — добавляем эту букву в массив bad_letters.
    else
      add_letter_to(@bad_letters, letter)

      @errors += 1

      lost? && @status = :lost
    end
  end

  # Метод, который спрашивает у пользователя следующую букву
  def ask_next_letter
    puts "\nВведите следующую букву"

    user_input = STDIN.gets.downcase.chomp.to_s

    next_step(user_input)
  end
end
