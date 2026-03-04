import { Controller } from "@hotwired/stimulus"

const FREQUENCY = 440;
// Times in milliseconds; note that Morse code dash time is 3 * dot time
const DOT_TIME = 60;
const DASH_TIME = DOT_TIME * 3;
const MORSE_CODE_DICTIONARY =
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
};

export default class extends Controller {
  static values = {
    message: String,
    translatedMessage: String
  }

  static targets = ["translatedMessageDisplay", "message"];

  connect(){
    this.dataMessage = this.element.dataset.message;
    this.dataTranslatedMessage = this.element.dataset.dataTranslatedMessage;
    if(this.hasMessageTarget){
      this.dataMessage = this.messageTarget.value;
    }
  }

  startAudio(){
    this.note_context = new (window.AudioContext || window.webkitAudioContext)();
    this.note_node = this.note_context.createOscillator();
    this.gain_node = this.note_context.createGain();
    this.note_node.frequency.value = FREQUENCY.toFixed(2);
    this.gain_node.gain.value = 0;
    this.note_node.connect(this.gain_node);
    this.gain_node.connect(this.note_context.destination);
    this.note_node.start();
    this.audioContextInitialized = true;
  }

  updateMessage(){
    if(this.hasMessageTarget){
      this.dataMessage = this.messageTarget.value;
    }
  }

  playBip() {
    console.log('it is working!');
  }

  startNotePlaying() {
    // Pass a start time of 0 so it starts ramping up immediately.
    this.gain_node.gain.setTargetAtTime(0.1, 0, 0.001)
  }

  stopNotePlaying() {
    // Pass a start time of 0 so it starts ramping down immediately.
    this.gain_node.gain.setTargetAtTime(0, 0, 0.001)
  }


  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  async playDash() {
    this.startNotePlaying();
    await this.sleep(DASH_TIME);
    this.stopNotePlaying();
  }

  async playDot() {
    this.startNotePlaying();
    await this.sleep(DOT_TIME);
    this.stopNotePlaying();
  }

  async playMessage() {
    if(!this.note_context){
      this.startAudio();
    }
    let words = this.dataMessage.split("/");
    for(let wordIndex = 0; wordIndex < words.length; wordIndex++){
      let characters = words[wordIndex].trim().split(" ");
      for(let characterIndex = 0; characterIndex < characters.length; characterIndex++){
        let character = characters[characterIndex];
        for(let bip of character){
          switch (bip){
            case ".":
              await this.playDot();
              break;
            case "-":
              await this.playDash();
              break;
            default:
              console.log('something is brokeded');
          }
          await this.sleep(DOT_TIME);
        }
        await this.sleep(DASH_TIME);
      }
      await this.sleep(DOT_TIME * 7);
    }
  }

  async translateMessage(){
    this.updateMessage();
    let result = "";
    // Break in words
    this.dataMessage.split("/").forEach( (word) => {
      // Break in letters
      word.trim().split(" ").forEach( (character) => {
        let newCharacter = MORSE_CODE_DICTIONARY[character];
        if(newCharacter === undefined || newCharacter === 'NaN'){
          result += "#";
        }
        else{
          result += newCharacter;
        }
      });
      result += " ";
    });
    this.dataTranslatedMessage = result;
    this.translatedMessageDisplayTarget.value = result;
    return result;
  }
}
