import { throttle } from '@ember/runloop';
import { computed, observer } from '@ember/object';
import Component from '@ember/component';
import _ from 'lodash';

export default Component.extend({
  tagName: 'textarea',
  attributeBindings: ['rows','cols'],

  poop: true,

  rows: 20,
  cols: 120,

  didInsertElement() {


    /* eslint-disable */
    let psconsole = this.$();
    if ( psconsole.length > 0 ) {
      this.set('psconsole', psconsole);
    }
    /* eslint-enable */
  },

  messageView: computed('messages.[]', function() {
    let messages = this.get('messages');
    throttle(this,'scrollToBottom', 500);
    return _(messages).takeRight(50).join("\n");
  }),

  messagesChanged: observer('messages.[]',function() {

    throttle(this,'scrollToBottom', 500);
    // Ember.run.scheduleOnce('afterRender', this, 'scrollToBottom');

  }),

  scrollToBottom() {
    /* eslint-disable */
    let psconsole = this.get('psconsole');
    if ( psconsole ) {
      psconsole.scrollTop(psconsole[0].scrollHeight - 380);
    }
    /* eslint-enable */
  },
});
