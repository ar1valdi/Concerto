import { init as initWaveformPlaylist } from '../waveform-playlist/src/app.js';
import { EventEmitter, default as createEventEmitter } from "event-emitter";

import controlsHTML from './controls.html';

const recordingConstraints = { audio: true };

export class DawTrack
{
  public id: number;
  public name: string;
  public takes: DawTrackTake[];
}

export class DawTrackTake
{
  public id: number;
  public name: string;

  public duration = 0;
  public startTime = 0;
  public endTime = 0;
  public gain = 1;
  public stereoPan = 0;
}

export class Daw {
  private tracks: DawTrack[];

  private playlist: any;
  private eventEmitter: EventEmitter.Emitter;

  public static async initialize(containerId: string): Promise<Daw>
  {
    // get microphone input stream
    let microphoneStream: MediaStream;
    try {
      microphoneStream = await navigator.mediaDevices.getUserMedia(recordingConstraints)
    }
    catch(err) {
      console.log(err);
      return;
    }

    var container = document.getElementById(containerId);
    if (!container)
      throw new Error("Could not find container with id: " + containerId);

    var options = {
      samplesPerPixel: 3000,
      waveHeight: 100,
      container: container,
      state: 'cursor',
      colors: {
        waveOutlineColor: '#005BBB',
        timeColor: 'grey',
        fadeColor: 'black'
      },
      timescale: true,
      controls: {
        show: true, //whether or not to include the track controls
        width: 200 //width of controls in pixels
      },
      seekStyle: 'line',
      zoomLevels: [100, 250, 500, 1000, 3000, 5000]
    }

    let daw = new Daw(options, microphoneStream);
    await daw.loadSamplePlaylist();

    // generate UI for the playlist
    container.insertAdjacentHTML('afterbegin', controlsHTML);


    // add event listeners to the UI
    let ee = daw.eventEmitter;
    $('#daw-pause').on('click', () => ee.emit("pause"));
    $('#daw-play').on('click', () => ee.emit("play"));
    $('#daw-stop').on('click', () => ee.emit("stop"));
    $('#daw-rewind').on('click', () => ee.emit("rewind"));
    $('#daw-forward').on('click', () => ee.emit("fastforward"));
    $('#daw-record').on('click', () => ee.emit("record"));
    $('#daw-zoom-out').on('click', () => ee.emit("zoomout"));
    $('#daw-zoom-in').on('click', () => ee.emit("zoomin"));
    $('#daw-cursor').on('click', function() {
      ee.emit("statechange", "cursor");
      toggleActive(this);
    });
    $('#daw-select').on('click', function() {
      ee.emit("statechange", "select");
      toggleActive(this);
    });
    $('#daw-shift').on('click', function() {
      ee.emit("statechange", "shift");
      toggleActive(this);
    });

    return daw;
  }

  public constructor(options: {}, userMediaStream: MediaStream) {
    this.eventEmitter = createEventEmitter();
    this.playlist = initWaveformPlaylist(options, this.eventEmitter);
    this.playlist.initRecorder(userMediaStream);
  }

  public async loadSamplePlaylist() {
    const trackList = [
      {
        src: "http://naomiaro.github.io/waveform-playlist/media/audio/BassDrums30.mp3",
        name: "Drums",
        gain: 0.5,

      },
      {
        src: "http://naomiaro.github.io/waveform-playlist/media/audio/Guitar30.mp3",
        name: "Guitar",
        gain: 0.5,
      },
    ];
    await this.playlist.loadTrackList(trackList);
  }
}


function toggleActive(node: HTMLElement) {
  var active = node.parentNode.querySelectorAll('.active');
  for (var i = 0; i < active.length; i++)
    active[i].classList.remove('active');
  node.classList.toggle('active');
}

