import _defaults from "lodash.defaultsdeep";
import h from "virtual-dom/h";
import diff from "virtual-dom/diff";
import patch from "virtual-dom/patch";
import InlineWorker from "inline-worker";

import { pixelsToSeconds } from "./utils/conversions";

import ScrollHook from "./render/ScrollHook";
import TimeScale from "./TimeScale";
import Track from "./Track";
import Playout from "./Playout";
import PlaylistEvents from "./PlaylistEvents";
import AnnotationList from "./annotation/AnnotationList";
import ExportWavWorkerFunction from "./utils/exportWavWorker";

export default class Playlist {
  constructor() {
    
    this.trackIdMap = new Map();
    this.tracks = [];
    this.soloedTracks = [];
    this.mutedTracks = [];
    this.collapsedTracks = [];
    this.playoutPromises = [];

    this.cursor = 0;
    this.playbackSeconds = 0;
    this.duration = 0;
    this.scrollLeft = 0;
    this.scrollTimer = undefined;
    this.shouldScrollToSelection = false;
    this.showTimescale = false;
    // whether a user is scrolling the waveform
    this.isScrolling = false;

    this.fadeType = "logarithmic";
    this.masterGain = 1;
    this.annotations = [];
    this.durationFormat = "hh:mm:ss.uuu";
    this.isAutomaticScroll = false;
    this.resetDrawTimer = undefined;

    this.mimeType = undefined;
    this.extension = undefined;

    this.isRecording = false;
  }

  // TODO extract into a plugin
  initExporter() {
    this.exportWorker = new InlineWorker(ExportWavWorkerFunction);
  }

  setShowTimeScale(show) {
    this.showTimescale = show;
  }

  setMono(mono) {
    this.mono = mono;
  }

  setExclSolo(exclSolo) {
    this.exclSolo = exclSolo;
  }

  setSeekStyle(style) {
    this.seekStyle = style;
  }

  getSeekStyle() {
    return this.seekStyle;
  }

  setSampleRate(sampleRate) {
    this.sampleRate = sampleRate;
  }

  setSamplesPerPixel(samplesPerPixel) {
    this.samplesPerPixel = samplesPerPixel;
  }

  setAudioContext(ac) {
    this.ac = ac;
    this.masterGainNode = ac.createGain();
  }

  getAudioContext() {
    return this.ac;
  }

  setControlOptions(controlOptions) {
    this.controls = controlOptions;
  }

  setWaveHeight(height) {
    this.waveHeight = height;
  }

  setCollapsedWaveHeight(height) {
    this.collapsedWaveHeight = height;
  }

  setColors(colors) {
    this.colors = colors;
  }

  setBarWidth(width) {
    this.barWidth = width;
  }

  setBarGap(width) {
    this.barGap = width;
  }

  setAnnotations(config) {
    const controlWidth = this.controls.show ? this.controls.width : 0;
    this.annotationList = new AnnotationList(
      this,
      config.annotations,
      config.controls,
      config.editable,
      config.linkEndpoints,
      config.isContinuousPlay,
      controlWidth
    );
  }

  setEffects(effectsGraph) {
    this.effectsGraph = effectsGraph;
  }

  setEventEmitter(ee) {
    this.ee = ee;
  }

  getEventEmitter() {
    return this.ee;
  }

  reRender()
  {
    this.draw(this.render());
  }

  reorderTracks(trackIdsOrder) {

    let trackIdIndexMap = new Map();
    for(let i = 0; i < trackIdsOrder.length; i++) {
        trackIdIndexMap.set(trackIdsOrder[i], i);
    }

    this.tracks.sort((a, b) => {
      return trackIdIndexMap.get(a.id) - trackIdIndexMap.get(b.id);
    });
  }
  
  restartPlay()
  {
    if (!this.isPlaying()) return;
    this.restartPlayFrom(this.playbackSeconds);
  }

  async addTrack(trackInfo)
  {
    let track = this.tracks.find(track => track.id == trackInfo.id);
    if (track != undefined) throw new Error("Track already exists");

    track = new Track(trackInfo.id);
    this.trackIdMap.set(track.id, track);
    this.tracks.push(track);
    await track.initializeAsync(trackInfo, this.ac, this.masterGainNode, this.ee, this.getState(), this.samplesPerPixel, this.sampleRate);
    if (trackInfo.muted) this.setMuteTrack(track);
    if (trackInfo.soloed) this.setSoloTrack(track);

    this.adjustDuration();
  } 

  async updateTrack(trackInfo, sourceChanged)
  {
    let track = this.getTrackById(trackInfo.id);
    if (track === undefined || track == null) throw new Error("Track does not exist");

    await track.initializeAsync(trackInfo, this.ac, this.masterGainNode, this.ee, this.getState(), this.samplesPerPixel, this.sampleRate, sourceChanged);
    if (trackInfo.muted) this.setMuteTrack(track);
    if (trackInfo.soloed) this.setSoloTrack(track);

    //const selection = trackInfo.selected;
    //if (selection !== undefined) {
    //  this.setActiveTrack(track);
    //  this.setTimeSelection(selection.start, selection.end);
    //}

    this.adjustDuration();
  }

  async loadTrackList(trackInfoList) {
    for(const trackInfo of trackInfoList)
    {
      await this.addTrack(trackInfo);
    }
    this.reRender();
    this.ee.emit(PlaylistEvents.AUDIO_SOURCES_RENDERED);
  }

  removeTrackById(id) {
    const track = this.getTrackById(id);
    if (track === undefined) throw new Error("Track does not exist");

    // if active track is removed, set active track to the first track to none
    if (this.getActiveTrack() === track)
        this.setActiveTrack(undefined);

    this.removeTrack(track);
  }

  setTrackVolumeById(id, volume) {
    const track = this.getTrackById(id);
    if (track === undefined) throw new Error("Track does not exist");
    track.setGainLevel(volume);
    this.drawRequest();
  }

  toggleTrackSoloById(id) {
    const track = this.getTrackById(id);
    if (track === undefined) throw new Error("Track does not exist");
    this.ee.emit(PlaylistEvents.SOLO, track);
  }

  toggleTrackMuteById(id) {
    const track = this.getTrackById(id);
    if (track === undefined) throw new Error("Track does not exist");
    this.ee.emit(PlaylistEvents.MUTE, track);
  }

  async clearTrackList(){
    await this.clear();
  }


  async getMicrophoneStream() {
    try {
      // disable noise suppression and echo cancellation
      let microphoneStream = await navigator.mediaDevices.getUserMedia({ audio: true, video: false, noiseSuppression: false, echoCancellation: false })
      return microphoneStream;
    }
    catch (err) {
      console.log(err);
      return null;
    }
  }


  async startRecordingTrackById(trackId) {
    const track = this.getTrackById(trackId);
    if (track === undefined) throw new Error("Track does not exist");
    await this.record(track);
  }

  async record(track) {
    this.isRecording = true;
    await this.initRecorder(track);

    const playoutPromises = [];
    const start = this.cursor;
    setTimeout(this.startAnimation(start), Track.playDelay * 1000);
    setTimeout(this.mediaRecorder.start(300), Track.playDelay * 1000);

    this.tracks.forEach((track) => {
      track.setState("none");
      playoutPromises.push(
        track.schedulePlay(this.ac.currentTime, start, undefined, {
          shouldPlay: this.shouldTrackPlay(track),
        })
      );
    });

    

    this.playoutPromises = playoutPromises;
    
  }

  async initRecorder(track) {
    const stream = await this.getMicrophoneStream();
    if (stream == null) {
      console.log("Failed to get microphone stream");
      return;
    }

    track.recordingUpdate(null, this.ac, this.masterGainNode, this.samplesPerPixel, this.sampleRate)

    this.mediaRecorder = new MediaRecorder(stream, { mimeType: this.mimeType });

    this.mediaRecorder.onstart = () => {
      const start = this.cursor;
      track.setEnabledStates();
      track.setStartTime(start);

      this.recordingTrack = track;

      this.chunks = [];
      this.blob = new Blob([], { type: "audio/ogg; codecs=opus" });

      this.recorderWorkerWorking = false;
    };

    // this.recorderWorker = new InlineWorker(RecorderWorkerFunction);

    this.mediaRecorder.ondataavailable = (e) => {
      this.chunks.push(e.data);

      if (!this.recorderWorkerWorking) {
        this.recorderWorkerWorking = true;

        const recording = new Blob(this.chunks, { type: "audio/ogg; codecs=opus"});
        track
        .recordingUpdate(recording, this.ac, this.masterGainNode, this.samplesPerPixel, this.sampleRate)
        .then(() => this.adjustDuration())
        .then(() => this.drawRequest())
        .then(() => this.recorderWorkerWorking = false);
        //const loader = LoaderFactory.createLoader(recording, this.ac);

        // loader.load().then((audioBuffer) => {
        //   this.recorderWorker.postMessage({
        //     samples: audioBuffer.getChannelData(0),
        //     samplesPerPixel: this.samplesPerPixel,
        //   });
        // });
      }
    }

    // this.recorderWorker.onmessage = (e) => {
    //   track.endTime = this.cursor;
    //   this.recordingTrack.setPeaks(e.data);
    //   this.recorderWorkerWorking = false;
    //   this.adjustDuration();
    //   this.drawRequest();
    // };

    this.mediaRecorder.onstop = () => {
      const recording = new Blob(this.chunks, { type: "audio/ogg; codecs=opus" });
      this.chunks = [];
      stream.getTracks().forEach((track) => track.stop());

      this.ee.emit(PlaylistEvents.RECORDING_FINISHED, track.id, recording, track.startTime);

      this.recordingTrack
        .recordingUpdate(recording, this.ac, this.masterGainNode, this.samplesPerPixel, this.sampleRate)
        .then(() => this.adjustDuration())
        .then(() => this.drawRequest());

      this.isRecording = false;
      this.recordingTrack = null;
      this.mediaRecorder = null;
    };

  }

  /*
    track instance of Track.
  */
  setActiveTrack(track) {
    this.activeTrack = track;
  }

  getActiveTrack() {
    return this.activeTrack;
  }

  isSegmentSelection() {
    return this.timeSelection.start !== this.timeSelection.end;
  }

  /*
    start, end in seconds.
  */
  setTimeSelection(start = 0, end) {
    this.timeSelection = {
      start,
      end: end === undefined ? start : end,
    };

    this.cursor = start;
  }

  async startOfflineRender(type) {
    if (this.isRendering) {
      return;
    }

    this.isRendering = true;
    this.offlineAudioContext = new (window.OfflineAudioContext || window.webkitOfflineAudioContext)(
      2,
      48000 * this.duration,
      48000
    );
    const setUpChain = [];

    this.ee.emit(
      "audiorenderingstarting",
      this.offlineAudioContext,
      setUpChain
    );

    const currentTime = this.offlineAudioContext.currentTime;
    const mg = this.offlineAudioContext.createGain();

    this.tracks.forEach((track) => {
      const playout = new Playout(this.offlineAudioContext, track.buffer, mg);
      playout.setEffects(track.effectsGraph);
      playout.setMasterEffects(this.effectsGraph);
      track.setOfflinePlayout(playout);

      track.schedulePlay(currentTime, 0, 0, {
        shouldPlay: this.shouldTrackPlay(track),
        masterGain: 1,
        isOffline: true,
      });
    });

    /*
      TODO cleanup of different audio playouts handling.
    */
    await Promise.all(setUpChain);
    const audioBuffer = await this.offlineAudioContext.startRendering();
    if (["buffer", "mp3", "opus", "aac"].includes(type)) {
      this.ee.emit(PlaylistEvents.AUDIO_RENDERING_FINISHED, type, audioBuffer);
      this.isRendering = false;
    } else if (type === "wav") {
      this.exportWorker.postMessage({
        command: "init",
        config: {
          sampleRate: 48000,
        },
      });

      // callback for `exportWAV`
      this.exportWorker.onmessage = (e) => {
        this.ee.emit(PlaylistEvents.AUDIO_RENDERING_FINISHED, type, e.data);
        this.isRendering = false;

        // clear out the buffer for next renderings.
        this.exportWorker.postMessage({
          command: "clear",
        });
      };

      // send the channel data from our buffer to the worker
      this.exportWorker.postMessage({
        command: "record",
        buffer: [audioBuffer.getChannelData(0), audioBuffer.getChannelData(1)],
      });

      this.exportWorker.postMessage({
        command: "exportWAV",
        type: "audio/wav",
      });
    }
  }

  getTimeSelection() {
    return this.timeSelection;
  }

  setState(state) {
    this.state = state;

    this.tracks.forEach((track) => {
      track.setState(state);
    });
  }

  getState() {
    return this.state;
  }

  setZoomIndex(index) {
    this.zoomIndex = index;
  }

  setZoomLevels(levels) {
    this.zoomLevels = levels;
  }

  setZoom(zoom) {
    this.samplesPerPixel = zoom;
    this.zoomIndex = this.zoomLevels.indexOf(zoom);
    this.tracks.forEach((track) => {
      track.calculatePeaks(zoom, this.sampleRate);
    });
  }

  setMuteTrack(track) {
    const index = this.mutedTracks.indexOf(track);
    if (index == -1)
      this.mutedTracks.push(track);
  }

  setSoloTrack(track) {
    const index = this.soloedTracks.indexOf(track);
    if (index == -1) {
      this.soloedTracks.push(track);
    }
  }

  muteTrack(track) {
    const index = this.mutedTracks.indexOf(track);

    if (index > -1) {
      this.mutedTracks.splice(index, 1);
    } else {
      this.mutedTracks.push(track);
    }
  }

  soloTrack(track) {
    const index = this.soloedTracks.indexOf(track);

    if (index > -1) {
      this.soloedTracks.splice(index, 1);
    } else if (this.exclSolo) {
      this.soloedTracks = [track];
    } else {
      this.soloedTracks.push(track);
    }
  }

  collapseTrack(track, opts) {
    if (opts.collapsed) {
      this.collapsedTracks.push(track);
    } else {
      const index = this.collapsedTracks.indexOf(track);

      if (index > -1) {
        this.collapsedTracks.splice(index, 1);
      }
    }
  }

  removeTrack(track) {
    if (track.isPlaying()) {
      track.scheduleStop();
    }

    const trackLists = [
      this.mutedTracks,
      this.soloedTracks,
      this.collapsedTracks,
      this.tracks,
    ];
    trackLists.forEach((list) => {
      const index = list.indexOf(track);
      if (index > -1) {
        list.splice(index, 1);
      }
    });

    this.trackIdMap.delete(track.id);
    this.adjustDuration();
  }

  adjustTrackPlayout() {
    this.tracks.forEach((track) => {
      track.setShouldPlay(this.shouldTrackPlay(track));
    });
  }

  adjustDuration() {
    this.duration = this.tracks.reduce(
      (duration, track) => Math.max(duration, track.getEndTime()),
      0
    );
  }

  shouldTrackPlay(track) {
    let shouldPlay;
    // if there are solo tracks, only they should play.
    if (this.soloedTracks.length > 0) {
      shouldPlay = false;
      if (this.soloedTracks.indexOf(track) > -1) {
        shouldPlay = true;
      }
    } else {
      // play all tracks except any muted tracks.
      shouldPlay = true;
      if (this.mutedTracks.indexOf(track) > -1) {
        shouldPlay = false;
      }
    }

    return shouldPlay;
  }

  isPlaying() {
    return this.tracks.reduce(
      (isPlaying, track) => isPlaying || track.isPlaying(),
      false
    );
  }

  /*
   *   returns the current point of time in the playlist in seconds.
   */
  getCurrentTime() {
    const cursorPos = this.lastSeeked || this.pausedAt || this.cursor;

    return cursorPos + this.getElapsedTime();
  }

  getElapsedTime() {
    return this.ac.currentTime - this.lastPlay;
  }

  setMasterGain(gain) {
    this.ee.emit(PlaylistEvents.MASTER_VOLUME_CHANGE, gain);
  }

  restartPlayFrom(start, end) {
    this.stopAnimation();

    this.tracks.forEach((editor) => {
      editor.scheduleStop();
    });

    return Promise.all(this.playoutPromises).then(
      this.play.bind(this, start, end)
    );
  }

  play(startTime, endTime) {
    clearTimeout(this.resetDrawTimer);

    const currentTime = this.ac.currentTime;
    const selected = this.getTimeSelection();
    const playoutPromises = [];

    const start =
      startTime === 0 ? 0 : startTime || this.pausedAt || this.cursor;
    let end = endTime;

    if (!end && selected.end !== selected.start && selected.end > start) {
      end = selected.end;
    }

    if (this.isPlaying()) {
      return this.restartPlayFrom(start, end);
    }

    // TODO refector this in upcoming modernisation.
    if (this.effectsGraph)
      this.tracks && this.tracks[0].playout.setMasterEffects(this.effectsGraph);


    for(const track of this.tracks) {
      if(this.state !== "shift")
        track.setState("cursor");
      let scheduledPlayPromise = track.schedulePlay(currentTime, start, end, {
        shouldPlay: this.shouldTrackPlay(track),
        masterGain: this.masterGain,
      });
      playoutPromises.push(scheduledPlayPromise);
    }

    this.lastPlay = currentTime;
    // use these to track when the playlist has fully stopped.
    this.playoutPromises = playoutPromises;
    // wait
    setTimeout(this.startAnimation(start), Track.playDelay * 1000);
    return Promise.all(this.playoutPromises);
  }

  pause() {
    if (!this.isPlaying()) {
      return Promise.all(this.playoutPromises);
    }

    this.pausedAt = this.getCurrentTime();
    return this.playbackReset();
  }

  stop() {
    if (this.mediaRecorder && this.mediaRecorder.state === "recording") {
      this.mediaRecorder.stop();
    }

    this.pausedAt = undefined;
    this.playbackSeconds = 0;
    this.shouldScrollToSelection = true;
    return this.playbackReset();
  }

  playbackReset() {
    this.lastSeeked = undefined;
    this.stopAnimation();

    this.tracks.forEach((track) => {
      track.scheduleStop();
      track.setState(this.getState());
    });

    // TODO improve this.
    this.masterGainNode.disconnect();
    this.drawRequest();
    return Promise.all(this.playoutPromises);
  }

  rewind() {
    return this.stop().then(() => {
      this.scrollLeft = 0;
      this.ee.emit(PlaylistEvents.SELECT, 0, 0);
    });
  }

  fastForward() {
    return this.stop().then(() => {
      if (this.viewDuration < this.duration) {
        this.scrollLeft = this.duration - this.viewDuration;
      } else {
        this.scrollLeft = 0;
      }

      this.ee.emit(PlaylistEvents.SELECT, this.duration, this.duration);
    });
  }

  clear() {
    return this.stop().then(() => {
      this.tracks = [];
      this.soloedTracks = [];
      this.mutedTracks = [];
      this.playoutPromises = [];

      this.cursor = 0;
      this.playbackSeconds = 0;
      this.duration = 0;
      this.scrollLeft = 0;

      this.seek(0, 0, undefined);
    });
  }

  startAnimation(startTime) {
    this.stopAnimation();
    this.lastDraw = this.ac.currentTime;
    this.animationRequest = window.requestAnimationFrame(() => {
      this.updateEditor(startTime);
    });
  }

  stopAnimation() {
    window.cancelAnimationFrame(this.animationRequest);
    this.lastDraw = undefined;
  }

  seek(start, end, track) {
    if (this.isPlaying()) {
      this.lastSeeked = start;
      this.pausedAt = undefined;
      this.restartPlayFrom(start);
    } else {
      // reset if it was paused.
      this.setActiveTrack(track || this.tracks[0]);
      this.pausedAt = start;
      this.setTimeSelection(start, end);
      if (this.getSeekStyle() === "fill") {
        this.playbackSeconds = start;
      }
    }
  }

  /*
   * Animation function for the playlist.
   * Keep under 16.7 milliseconds based on a typical screen refresh rate of 60fps.
   */
  updateEditor(cursor) {
    const currentTime = this.ac.currentTime;
    const selection = this.getTimeSelection();
    const cursorPos = cursor || this.cursor;
    const elapsed = currentTime - this.lastDraw;

    if (this.isPlaying() || this.isRecording) {
      const playbackSeconds = cursorPos + elapsed;
      this.ee.emit(PlaylistEvents.TIME_UPDATE, playbackSeconds);
      this.animationRequest = window.requestAnimationFrame(() => {
        this.updateEditor(playbackSeconds);
      });

      this.playbackSeconds = playbackSeconds;
      this.draw(this.render());
      this.lastDraw = currentTime;
    }
    else {
      if (
        cursorPos + elapsed >=
        (this.isSegmentSelection() ? selection.end : this.duration)
      ) {
        this.ee.emit(PlaylistEvents.FINISHED_PLAYING);
      }

      this.stopAnimation();

      this.resetDrawTimer = setTimeout(() => {
        this.pausedAt = undefined;
        this.lastSeeked = undefined;
        this.setState(this.getState());

        this.playbackSeconds = 0;
        this.draw(this.render());
      }, 0);
    }
  }

  drawRequest() {
    window.requestAnimationFrame(() => {
      this.draw(this.render());
    });
  }

  draw(newTree) {
    const patches = diff(this.tree, newTree);
    this.rootNode = patch(this.rootNode, patches);
    this.tree = newTree;

    // use for fast forwarding.
    this.viewDuration = pixelsToSeconds(
      this.rootNode.clientWidth - this.controls.width,
      this.samplesPerPixel,
      this.sampleRate
    );
  }

  getTrackRenderData(data = {}) {
    const defaults = {
      height: this.waveHeight,
      resolution: this.samplesPerPixel,
      sampleRate: this.sampleRate,
      controls: this.controls,
      isActive: false,
      timeSelection: this.getTimeSelection(),
      playlistLength: this.duration,
      playbackSeconds: this.playbackSeconds,
      colors: this.colors,
      barWidth: this.barWidth,
      barGap: this.barGap,
    };

    return _defaults({}, data, defaults);
  }

  isActiveTrack(track) {
    const activeTrack = this.getActiveTrack();

    if (this.isSegmentSelection()) {
      return activeTrack === track;
    }

    return true;
  }

  renderAnnotations() {
    return this.annotationList.render();
  }

  renderTimeScale() {
    const controlWidth = this.controls.show ? this.controls.width : 0;
    const timeScale = new TimeScale(
      this.duration,
      this.scrollLeft,
      this.samplesPerPixel,
      this.sampleRate,
      controlWidth,
      this.colors
    );

    return timeScale.render();
  }

  renderTrackSection() {
    const trackElements = this.tracks.map((track) => {
      const collapsed = this.collapsedTracks.indexOf(track) > -1;
      return track.render(
        this.getTrackRenderData({
          isActive: this.isActiveTrack(track),
          shouldPlay: this.shouldTrackPlay(track),
          soloed: this.soloedTracks.indexOf(track) > -1,
          muted: this.mutedTracks.indexOf(track) > -1,
          collapsed,
          height: collapsed ? this.collapsedWaveHeight : this.waveHeight,
          barGap: this.barGap,
          barWidth: this.barWidth,
        })
      );
    });

    return h(
      "div.playlist-tracks",
      {
        attributes: {
          style: "overflow-x: scroll; overflow-y: auto;",
        },
        onscroll: (e) => {
          this.scrollLeft = pixelsToSeconds(
            e.target.scrollLeft,
            this.samplesPerPixel,
            this.sampleRate
          );

          this.ee.emit(PlaylistEvents.SCROLL);
        },
        hook: new ScrollHook(this),
      },
      trackElements
    );
  }

  render() {
    const containerChildren = [];

    if (this.showTimescale) {
      containerChildren.push(this.renderTimeScale());
    }

    containerChildren.push(this.renderTrackSection());

    if (this.annotationList.length) {
      containerChildren.push(this.renderAnnotations());
    }

    return h(
      "div.playlist",
      {
        attributes: {
          style: "overflow: hidden; position: relative;",
        },
      },
      containerChildren
    );
  }

  getInfo() {
    const tracks = [];

    this.tracks.forEach((track) => {
      tracks.push(track.getTrackDetails());
    });

    return {
      tracks,
      effects: this.effectsGraph,
    };
  }

  getTrackById(id) {
    return this.trackIdMap.get(id);
  }

  setUpEventEmitter() {
    const ee = this.ee;

    ee.on(PlaylistEvents.SET_AUTOMATIC_SCROLL, (val) => {
      this.isAutomaticScroll = val;
    });

    ee.on(PlaylistEvents.SET_DURATION_FORMAT, (format) => {
      this.durationFormat = format;
      this.drawRequest();
    });

    ee.on(PlaylistEvents.SELECT, (start, end, track) => {
      if (this.isPlaying()) {
        this.lastSeeked = start;
        this.pausedAt = undefined;
        this.restartPlayFrom(start);
      } else {
        // reset if it was paused.
        this.seek(start, end, track);
        this.ee.emit(PlaylistEvents.TIME_UPDATE, start);
        this.drawRequest();
      }
    });

    ee.on(PlaylistEvents.START_AUDIO_RENDERING, (type) => {
      this.startOfflineRender(type);
    });

    ee.on(PlaylistEvents.STATE_CHANGE, (state) => {
      this.setState(state);
      this.drawRequest();
    });

    ee.on(PlaylistEvents.SHIFT, (deltaTime, track) => {
      track.setStartTime(track.getStartTime() + deltaTime);
      this.adjustDuration();
      this.drawRequest();
    });

    ee.on(PlaylistEvents.COMPLETE_SHIFT, (deltaTime, track) => {
      track.setStartTime(track.getStartTime() + deltaTime);
      this.adjustDuration();
      this.drawRequest();

      if (this.isPlaying())
        this.restartPlayFrom(this.playbackSeconds);

      this.ee.emit(PlaylistEvents.TRACK_START_TIME_UPDATE, track.id, track.getStartTime());
    });


    ee.on(PlaylistEvents.RECORD, () => {
      this.record();
    });

    ee.on(PlaylistEvents.PLAY, (start, end) => {
      this.play(start, end);
    });

    ee.on(PlaylistEvents.PAUSE, () => {
      this.pause();
    });

    ee.on(PlaylistEvents.STOP, () => {
      this.stop();
    });

    ee.on(PlaylistEvents.REWIND, () => {
      this.rewind();
    });

    ee.on(PlaylistEvents.FAST_FORWARD, () => {
      this.fastForward();
    });

    ee.on(PlaylistEvents.CLEAR, () => {
      this.clear().then(() => {
        this.drawRequest();
      });
    });

    ee.on(PlaylistEvents.SOLO, (track) => {
      this.soloTrack(track);
      this.adjustTrackPlayout();
      this.drawRequest();
    });

    ee.on(PlaylistEvents.MUTE, (track) => {
      this.muteTrack(track);
      this.adjustTrackPlayout();
      this.drawRequest();
    });

    ee.on(PlaylistEvents.REMOVE_TRACK, (track) => {
      this.removeTrack(track);
      this.adjustTrackPlayout();
      this.drawRequest();
    });

    ee.on(PlaylistEvents.CHANGE_TRACK_VIEW, (track, opts) => {
      this.collapseTrack(track, opts);
      this.drawRequest();
    });

    ee.on(PlaylistEvents.VOLUME_CHANGE, (volume, track) => {
      track.setGainLevel(volume / 100);
      this.drawRequest();
    });

    ee.on(PlaylistEvents.MASTER_VOLUME_CHANGE, (volume) => {
      this.masterGain = volume / 100;
      this.tracks.forEach((track) => {
        track.setMasterGainLevel(this.masterGain);
      });
    });

    ee.on(PlaylistEvents.FADE_IN, (duration, track) => {
      track.setFadeIn(duration, this.fadeType);
      this.drawRequest();
    });

    ee.on(PlaylistEvents.FADE_OUT, (duration, track) => {
      track.setFadeOut(duration, this.fadeType);
      this.drawRequest();
    });

    ee.on(PlaylistEvents.STEREO_PAN, (panvalue, track) => {
      track.setStereoPanValue(panvalue);
      this.drawRequest();
    });

    ee.on(PlaylistEvents.FADE_TYPE, (type) => {
      this.fadeType = type;
    });

    ee.on(PlaylistEvents.NEW_TRACK, (file) => {
      this.loadTrackList([
        {
          src: file,
          name: file.name,
        },
      ]);
    });

    ee.on(PlaylistEvents.CUT, () => {
      const track = this.getActiveTrack();
      const timeSelection = this.getTimeSelection();

      track.removePart(timeSelection.start, timeSelection.end, this.ac, track);
      track.calculatePeaks(this.samplesPerPixel, this.sampleRate);

      this.setTimeSelection(0, 0);
      this.adjustDuration();
      this.drawRequest();
      this.ee.emit(PlaylistEvents.CUT_FINISHED);
    });

    ee.on(PlaylistEvents.RAZOR_CUT, () => {
      const Track = this.getActiveTrack();
      const timeSelection = this.getTimeSelection();
      Track.razorCut(timeSelection.start, this.ac, Track);
    });

    ee.on(PlaylistEvents.TRIM, () => {
      const track = this.getActiveTrack();
      const timeSelection = this.getTimeSelection();

      track.trim(timeSelection.start, timeSelection.end);
      track.calculatePeaks(this.samplesPerPixel, this.sampleRate);

      this.setTimeSelection(0, 0);
      this.adjustDuration();
      this.drawRequest();
    });

    ee.on(PlaylistEvents.SPLIT, () => {
      const track = this.getActiveTrack();
      const timeSelection = this.getTimeSelection();
      const timeSelectionStart = timeSelection.start;
      this.createTrackFromSplit({
        trackToSplit: track,
        name: track.name + "_1",
        splitTime: timeSelectionStart,
      });
      track.trim(track.startTime, timeSelectionStart);
      if (track.fadeOut) {
        track.removeFade(track.fadeOut);
        track.fadeOut = undefined;
      }

      track.calculatePeaks(this.samplesPerPixel, this.sampleRate);

      this.drawRequest();
    });

    ee.on(PlaylistEvents.ZOOM_IN, () => {
      const zoomIndex = Math.max(0, this.zoomIndex - 1);
      const zoom = this.zoomLevels[zoomIndex];

      if (zoom !== this.samplesPerPixel) {
        this.setZoom(zoom);
        this.drawRequest();
      }
    });

    ee.on(PlaylistEvents.ZOOM_OUT, () => {
      const zoomIndex = Math.min(
        this.zoomLevels.length - 1,
        this.zoomIndex + 1
      );
      const zoom = this.zoomLevels[zoomIndex];

      if (zoom !== this.samplesPerPixel) {
        this.setZoom(zoom);
        this.drawRequest();
      }
    });

    ee.on(PlaylistEvents.SCROLL, () => {
      this.isScrolling = true;
      this.drawRequest();
      clearTimeout(this.scrollTimer);
      this.scrollTimer = setTimeout(() => {
        this.isScrolling = false;
      }, 200);
    });
  }

}
