import { Controller } from "@hotwired/stimulus"

const FREQUENCY = 440;
// Times in milliseconds; note that Morse code dash time is 3 * dot time
const DOT_TIME = 60;
const DASH_TIME = DOT_TIME * 3;

export default class extends Controller {

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
}
