import { inject as service } from '@ember/service';
import { run, schedule } from '@ember/runloop';
import EmberObject from '@ember/object';
import ENV from 'aptamer/config/environment';
import PhoenixSocket from 'ember-phoenix/services/phoenix-socket';

const FileContents = EmberObject.extend({
  channel: null,
  fileId: null,

  init() {
    this._super(...arguments);
    this.channel.on("file_contents", (payload) => this._onFileContents(payload) );
    this.messages = [];
  },

  start() {
    this.channel.join();
  },

  stop() {
    this.channel.leave();
    this.messages.clear();
  },

  _onFileContents(payload) {
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
  currentContentsChannel: null,

  init() {
    this._super(...arguments);
    this.on('open', () => {

      /* eslint-disable */
      console.log('File contents socket was opened');
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

    let channel = this.joinChannel("file:contents", {});

    channel.on("file_contents", (payload) => this._onFileContents(payload));

    channel.onError( _e => {
      /* eslint-disable */
      console.log("Channel Error", _e);
      /* eslint-enable */
    });

    this.set('contentsChannel', channel);

  },

  captureContents(fileId, onComplete) {
    this.stopCurrentCapture();

    let channel = this.socket.channel(`file:contents:${fileId}`);
    let contents = FileContents.create({
      channel,
      fileId,
    });

    contents.start();

    this.set('currentContentsChannel', contents);

    channel.push('get_contents', {body: fileId})
    .receive('ok', response => {
      onComplete(response.body)
    })
    .receive('error', _response => {
      onComplete("Error")
    })
  },

  stopCurrentCapture() {
    let currentChannel = this.currentContentsChannel;
    if ( currentChannel != null ) {
      currentChannel.stop();
    }
  },

  reset() {
    let channel = this.contentsChannel;
    if ( channel ) {
      channel.leave();
    }
  },
});
