import { inject as service } from '@ember/service';
import { run, schedule } from '@ember/runloop';
import EmberObject from '@ember/object';
import ENV from 'aptamer/config/environment';
import PhoenixSocket from 'phoenix/services/phoenix-socket';

const FileContents = EmberObject.extend({
  channel: null,
  fileId: null,

  init() {
    this._super(...arguments);
    this.get('channel').on("file_contents", (payload) => this._onFileContents(payload) );
    this.messages = [];
  },

  start() {
    this.get('channel').join();
  },

  stop() {
    this.get('channel').leave();
    this.get('messages').clear();
  },

  _onFileContents(payload) {
    run(() => {
      schedule('sync', () => {
        let messages = this.get('messages');
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

    let channel = this.get('socket').channel(`file:contents:${fileId}`);
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
    let currentChannel = this.get('currentContentsChannel');
    if ( currentChannel != null ) {
      currentChannel.stop();
    }
  },

  reset() {
    let channel = this.get('contentsChannel');
    if ( channel ) {
      channel.leave();
    }
  },
});
