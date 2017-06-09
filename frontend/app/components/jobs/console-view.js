import Ember from 'ember';
import _ from 'lodash';

export default Ember.Component.extend({
  tagName: 'textarea',
  attributeBindings: ['rows','cols'],

  poop: true,

  rows: 20,
  cols: 120,

  didInsertElement() {

    let psconsole = this.$();
    if ( psconsole.length > 0 ) {
      this.set('psconsole', psconsole);
    }
  },

  messageView: Ember.computed('messages.[]', function() {
    let messages = this.get('messages');
    Ember.run.throttle(this,'scrollToBottom', 500);
    return _(messages).takeRight(50).join("\n");
  }),

  messagesChanged: Ember.observer('messages.[]',function() {

    Ember.run.throttle(this,'scrollToBottom', 500);
    // Ember.run.scheduleOnce('afterRender', this, 'scrollToBottom');

  }),

  scrollToBottom() {
    console.log('scrolltobottom');
    let psconsole = this.get('psconsole');
    /* eslint-disable */
    if ( psconsole ) {
      psconsole.scrollTop(psconsole[0].scrollHeight - 380);
    }
    /* eslint-enable */
  },
});
