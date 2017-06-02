import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'textarea',
  attributeBindings: ['rows','cols'],
  rows: 20,
  cols: 120,

  messagesChanged: Ember.observer('messages.[]',function() {

    Ember.run(() => {

      Ember.run.schedule('render', () => {
        /* eslint-disable */
        let psconsole = this.$();
        if ( psconsole.length > 0 ) {
          psconsole.scrollTop(psconsole[0].scrollHeight - psconsole.height());
        }
        /* eslint-enable */

      });
    });
  }),

});
