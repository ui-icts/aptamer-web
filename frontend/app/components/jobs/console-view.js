import { throttle } from '@ember/runloop';
import { computed } from '@ember/object';
import Component from '@ember/component';
import _ from 'lodash';

export default Component.extend({
  tagName: 'textarea',
  attributeBindings: ['rows','cols'],

  poop: true,

  rows: 20,
  cols: 120,

  messageView: computed('messages.[]', function() {
    let messages = this.messages;
    throttle(this,'scrollToBottom', 500);
    return _(messages).takeRight(50).join("\n");
  }),

  didInsertElement() {

    /* eslint-disable */
    let psconsole = this.$();
    if ( psconsole.length > 0 ) {
      this.set('psconsole', psconsole);
    }
    /* eslint-enable */
  },

  didRender() {
    this._super(...arguments);
    throttle(this,'scrollToBottom', 500);
  },

  scrollToBottom() {
    /* eslint-disable */
    let psconsole = this.psconsole;
    if ( psconsole ) {
      psconsole.scrollTop(psconsole[0].scrollHeight - 380);
    }
    /* eslint-enable */
  },
});
