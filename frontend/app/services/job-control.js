import Ember from 'ember';
import ENV from 'aptamer/config/environment';
import PhoenixSocket from 'phoenix/services/phoenix-socket';

const JobOutput = Ember.Object.extend({
  channel: null,
  jobId: null,
  messages: [],

  init() {
    this.get('channel').on("job_output", (payload) => this._onJobOutput(payload) );
  },

  start() {
    this.get('channel').join();
  },

  stop() {
    this.get('channel').leave();
    this.get('messages').clear();
  },

  _onJobOutput(payload) {
    Ember.run(() => {
      Ember.run.schedule('sync', () => {
        let messages = this.get('messages');
        messages.pushObjects(payload.lines);
      });
    });
  },
});

export default PhoenixSocket.extend({
  store: Ember.inject.service(),
  currentOutputChannel: null,

  init() {
    this.on('open', () => {

      /* eslint-disable */
      console.log('Socket was opened');
      /* eslint-enable */
    });

    this.on('close', () => {
      /* eslint-disable */
      console.log('Closing socket...');
      /* eslint-enable */
    });
  },

  connect() {

    if ( this.get('isHealthy') === true ) {
      return;
    }

    this._super(`${ENV.rootURL}socket`, {
      // logger: ((kind, msg, data) => {
      //   #<{(| eslint-disable |)}>#
      //   console.log(`${kind}: ${msg}`, data);
      //   #<{(| eslint-enable |)}>#
      // })
    });

    let channel = this.joinChannel("jobs:status", {});

    channel.on("job_output", (payload) => this._onJobOutput(payload) );
    channel.on("status_change", (payload) => this._onStatusChange(payload) );
    channel.on("file_added", (payload) => this._onFileAdded(payload) );

    channel.onError( _e => {
      /* eslint-disable */
      console.log("Channel Error", _e);
      /* eslint-enable */
    });

    this.set('statusChannel', channel );

  },

  captureOutput(jobId) {

    this.stopCurrentCapture();

    let channel = this.get('socket').channel(`jobs:${jobId}`,{messagePosition: 0});

    let output = JobOutput.create({
      channel,
      jobId,
    });

    output.start();

    this.set('currentOutputChannel', output );

    return output;
  },

  stopCurrentCapture() {
    let currentOutput = this.get('currentOutputChannel');
    if ( currentOutput != null ) {
      currentOutput.stop();
    }
  },

  _onStatusChange(payload) {
    this.get('store').pushPayload(payload);
  },

  _onFileAdded(payload) {
    this.get('store').pushPayload(payload);
  },

  reset() {
    let channel = this.get('statusChannel');
    if ( channel ) {
      channel.leave();
    }
  },
});
