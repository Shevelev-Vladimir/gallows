# encoding: utf-8

class WordReader
  def get_word(input, file_path)
    # Даём пользователю возможность загадать слово в командной строке.
    return input unless input.nil?

    # Если слово в командной строке не загадано,
    return unless File.exist?(file_path)
    # то берём его из файла.
    lines = File.readlines(file_path, encoding: 'UTF-8')

    lines.sample.chomp.strip
  end
end
