class Message < ApplicationRecord
  validates :contents, presence: true
  validates :contents, format: { with: /[.|-| | \/]*/, message: 'Messages can only contain ".", "-", and " " with "/" for word breaks.' }
  validates :response, format: { with: /[.|-| | \/]*/, message: 'Responses can only contain ".", "-", and " " with "/" for word breaks.' }
  belongs_to :user

  def translate_message!
    result = ""
    # Break in words
    self.contents.split("/").each do |word|
      # Break in letters
      word.strip.split(" ").each do |character|
        new_character = morse_code_dictionary[character.to_sym]
        if new_character == nil
          result = result + "#"
        else
          result = result + new_character
        end
      end
      result = result + " "
    end
    self.translated_message = result
    result
  end

  def morse_code_dictionary
    {
     ".-": "A",
     "-...": "B",
     "-.-.": "C",
     "-..": "D",
     ".": "E",
     "..-.": "F",
     "--.": "G",
     "....": "H",
     "..": "I",
     ".---": "J",
     "-.-": "K",
     ".-..": "L",
     "--": "M",
     "-.": "N",
     "---": "O",
     ".--.": "P",
     "--.-": "Q",
     ".-.": "R",
     "...": "S",
     "-": "T",
     "..-": "U",
     "...-": "V",
     ".--": "W",
     "-..-": "X",
     "-.--": "Y",
     "--..": "Z",
     ".----": "1",
     "..---": "2",
     "...--": "3",
     "....-": "4",
     ".....": "5",
     "-....": "6",
     "--...": "7",
     "---..": "8",
     "----.": "9",
     "-----": "0",
     ".-.-.-": ".",
     "--..--": ",",
     "..--..": "?",
     "---...": ":",
     "-.-.-.": ";",
     "-....-": "-",
     ".-..-.": '"',
     "-.-.--": "!"
    }
  end
end
