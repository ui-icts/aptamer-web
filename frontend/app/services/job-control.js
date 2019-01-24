import { inject as service } from '@ember/service';
import { run, schedule } from '@ember/runloop';
import EmberObject from '@ember/object';
import ENV from 'aptamer/config/environment';
import PhoenixSocket from 'ember-phoenix/services/phoenix-socket';

const JobOutput = EmberObject.extend({
  channel: null,
  jobId: null,

  init() {
    this._super(...arguments);

    this.channel.on("job_output", (payload) => this._onJobOutput(payload) );
    this.messages =  [];
  },

  start() {
    this.channel.join();
  },

  stop() {
    this.channel.leave();
    this.messages.clear();
  },

  _onJobOutput(payload) {
    run(() => {
      schedule('sync', () => {
        let messages = this.messages;
        messages.pushObjects(payload.lines);
      });
    });
  },
});

export default PhoenixSocket.extend({
  store: service(),
  currentOutputChannel: null,

  init() {
    this._super(...arguments);
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

    if ( this.isHealthy === true ) {
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

    let channel = this.socket.channel(`jobs:${jobId}`,{messagePosition: 0});

    let output = JobOutput.create({
      channel,
      jobId,
    });

    output.start();

    this.set('currentOutputChannel', output );

    return output;
  },

  stopCurrentCapture() {
    let currentOutput = this.currentOutputChannel;
    if ( currentOutput != null ) {
      currentOutput.stop();
    }
  },

  _onStatusChange(payload) {
    this.store.pushPayload(payload);
  },

  _onFileAdded(payload) {
    this.store.pushPayload(payload);
  },

  reset() {
    let channel = this.statusChannel;
    if ( channel ) {
      channel.leave();
    }
  },
});
