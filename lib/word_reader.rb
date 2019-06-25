# encoding: utf-8

class WordReader
  def get_word(input, file_path)
  # Даём пользователю возможность загадать слово в командной строке.
    if input != nil
      hide_word = input
    # Если слово в командной строке не загадано, то берём его из файла.
    else
      file = File.new(file_path, "r:UTF-8")
      lines = file.readlines
      file.close

      lines.sample.chomp.strip
    end
  end
end
