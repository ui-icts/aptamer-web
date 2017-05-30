import Ember from 'ember';
import { Socket } from 'phoenix';
import $ from 'jquery';

export default Ember.Component.extend({

  jobText: 'Test1',
  messages: ["Let's rock and roll!"],
  show: false,

  log(msg) {

    let messages = this.get('messages');
    messages.pushObject(msg);
  },

  actions: {
    showHide() {
      this.toggleProperty('show');
    },

    start() {
      const log = this.log.bind(this);

      log("Starting....");

      let socket = new Socket('ws://localhost:4000/socket', {
          logger: ((kind, msg, data) => {
                /* eslint-disable */
                console.log(`${kind}: ${msg}`, data);
                /* eslint-enable */
              })
      });

      socket.onClose( _e => log("Closing socket...."));

      this.set('socket', socket)
      socket.connect();
      let channel = socket.channel("jobs:status", {});

      channel.on("start_job", payload => {
        log(`Received start_job broadcast: ${payload.body}`);
      });

      channel.on("job_output", payload => {

        Ember.run(() => {
          Ember.run.schedule('actions', () => {
            log(`JOB: ${payload.line}`);
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
      });

      channel.onError( _e => {
        log("Got error on channel");
        /* eslint-disable */
        console.log("Channel Error", _e);
        /* eslint-enable */
      });

      channel.join()
        .receive("ok", _resp => {
          log("Connected to jobs:status channel");
        })
        .receive("error", _resp => {
          log("Error connecting to jobs:status");
        });
      this.set('channel', channel);
    },

    reset() {
      let channel = this.get('channel');
      if ( channel ) {
        channel.leave();
      }

      this.get('messages').clear();
    },

    startJob() {
      let channel = this.get('channel');
      let log = this.log.bind(this);

      if ( channel ) {
        this.log("Sending start_job");
        channel.push("start_job", {body: this.get('jobText')}).receive("ok", (reply) => {

          log(`Received job_started reply: ${reply.body}`);

        });
      }
    },
  }
});
