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
                log(`${kind}: ${msg}`);
              })
      });

      this.set('socket', socket)
      socket.connect();
      let channel = socket.channel("jobs:status", {});
      channel.join()
        .receive("ok", resp => {
          log("Connected to jobs:status channel");
          console.log("OK Resp", resp);
        })
        .receive("error", resp => {
          log("Error connecting to jobs:status");
          console.log("ER Resp", resp);
        });
    }
  }
});
