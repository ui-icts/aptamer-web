import Ember from 'ember';
import PhoenixSocket from 'phoenix/services/phoenix-socket';
import $ from 'jquery';

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
      Ember.run.schedule('actions', () => {
        let messages = this.get('messages');
        if ( payload.hasOwnProperty('lines') ) {
          messages.pushObjects(payload.lines);
        } else if ( payload.hasOwnProperty('line') ) {
          messages.pushObject(payload.line);
        } else if ( typeof payload === 'string' ) {
          messages.pushObject(payload)
        }
      });
    });
  },
});

export default PhoenixSocket.extend({
  store: Ember.inject.service(),
  currentOutputChannel: null,
  messages: [],

  init() {
    this.on('open', () => {
      console.log('Socket was opened');
    });

    this.on('close', () => {
      console.log('Closing socket...');
    });
  },

  connect() {
    this._super('ws://localhost:4000/socket', {
      logger: ((kind, msg, data) => {
        /* eslint-disable */
        console.log(`${kind}: ${msg}`, data);
        /* eslint-enable */
      })
    });

    let channel = this.joinChannel("jobs:status", {});

    channel.on("job_output", (payload) => this._onJobOutput(payload) );
    channel.on("status_change", (payload) => this._onStatusChange(payload) );

    channel.onError( _e => {
      this.recordMessage("Got error on channel");
      /* eslint-disable */
      console.log("Channel Error", _e);
      /* eslint-enable */
    });

    this.set('statusChannel', channel );

  },

  captureOutput(jobId) {

    let currentOutput = this.get('currentOutputChannel');
    console.log("current channel", currentOutput);
    if ( currentOutput != null ) {
      currentOutput.stop();
    }

    let channel = this.get('socket').channel(`jobs:${jobId}`,{messagePosition: 0});

    let output = JobOutput.create({
      channel,
      jobId,
    });

    output.start();

    this.set('currentOutputChannel', output );

    return output;
  },

  startJob(jobText) {
    let channel = this.get('statusChannel');

    if ( channel ) {
      this._recordMessage("Sending start_job");
      channel.push("start_job", {body: jobText}).receive("ok", (reply) => {

        this._recordMessage(`Received job_started reply: ${reply.body}`);

      });
    }

  },

  _recordMessage(msg) {
    this.get('messages').pushObject(msg);
  },

  _onJobStart(payload) {
    this._recordMessage(`Received start_job broadcast: ${payload.body}`);
  },

  _onStatusChange(payload) {
    this.get('store').pushPayload(payload);
  },

  reset() {
    let channel = this.get('statusChannel');
    if ( channel ) {
      channel.leave();
    }

    this.get('messages').clear();
  },
});
