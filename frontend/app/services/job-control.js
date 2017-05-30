import Ember from 'ember';
import PhoenixSocket from 'phoenix/services/phoenix-socket';
import $ from 'jquery';

export default PhoenixSocket.extend({
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

    channel.onError( _e => {
      this.recordMessage("Got error on channel");
      /* eslint-disable */
      console.log("Channel Error", _e);
      /* eslint-enable */
    });

    this.set('channel', channel );

  },

  startJob(jobText) {
    let channel = this.get('channel');

    if ( channel ) {
      this.recordMessage("Sending start_job");
      channel.push("start_job", {body: jobText}).receive("ok", (reply) => {

        this.recordMessage(`Received job_started reply: ${reply.body}`);

      });
    }

  },

  recordMessage(msg) {
    this.get('messages').pushObject(msg);
  },

  _onJobStart(payload) {
    this.recordMessage(`Received start_job broadcast: ${payload.body}`);
  },

  _onJobOutput(payload) {
    console.log("_onJobOutput", arguments);
    console.log("_onJobOutput", payload);

    Ember.run(() => {
      Ember.run.schedule('actions', () => {
        this.recordMessage(`JOB: ${payload.line}`);
      });

      Ember.run.schedule('render', () => {
        /* eslint-disable */
        let psconsole = $('#outputPane');
        if ( psconsole ) {
          psconsole.scrollTop(psconsole[0].scrollHeight - psconsole.height());
        }
        /* eslint-enable */

      });
    });
  },

  reset() {
    let channel = this.get('channel');
    if ( channel ) {
      channel.leave();
    }

    this.get('messages').clear();
  },
});
