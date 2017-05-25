import Ember from 'ember';
import { Socket } from 'phoenix';

export default Ember.Component.extend({

  messages: ["Let's rock and roll!"],

  log(msg) {

    let messages = this.get('messages');
    messages.pushObject(msg);
  },

  actions: {
    start() {
      const log = this.log.bind(this);

      log("Starting....");

      let socket = new Socket('ws://localhost:4000/socket', {
          logger: ((kind, msg, data) => {
                console.log(`${kind}: ${msg}`, data);
              })
      });

      socket.onClose( e => log("Closing socket...."));

      this.set('socket', socket)
      socket.connect();
      let channel = socket.channel("jobs:status", {});

      channel.on("start_job", payload => {
        log(`Received start_job broadcast: ${payload.body}`);
      });

      channel.onError( e => {
        log("Got error on channel");
        console.log("Channel Error", e);
      });

      channel.join()
        .receive("ok", resp => {
          log("Connected to jobs:status channel");
          console.log("OK Resp", resp);
        })
        .receive("error", resp => {
          log("Error connecting to jobs:status");
          console.log("ER Resp", resp);
        });
      this.set('channel', channel);
    },

    reset() {
      let channel = this.get('channel');
      if ( channel ) {
        channel.leave();
      }
    },

    startJob() {
      let channel = this.get('channel');
      if ( channel ) {
        this.log("Sending start_job");
        channel.push("start_job", {body: "Test job"}).receive("ok", (reply) => {
          this.log(`Received job_started reply: ${reply.body}`);
        });
      }
    },
  }
});
