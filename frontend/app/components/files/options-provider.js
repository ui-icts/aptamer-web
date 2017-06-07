import Ember from 'ember';
import { task, timeout } from 'ember-concurrency';

/**
 * Acts as a container/provider for exposing
 * the options that should be managed for a particular
 * file.
 * This can change based on the fileType / command that
 * is selected and may be sourced from user preferences
 * or stored on the file itself.
 */
export default Ember.Component.extend({

  init() {
    this._super(...arguments);
    //trigger file computed?
    this.get('loadOptions').perform();
  },

  loadOptions: task( function * () {
    let file = this.get('file');
    let store = file.get('store');

    let options = yield store.query('create-graph-options', {
      filter: {
        forFile: file.get('id')
      }
    });

    if ( Ember.isEmpty(options) ) {
      options = store.createRecord('create-graph-options');
    } else {
      options = options.get('firstObject');
    }

    this.set('createGraphOptions', options );

  }).drop(),

});
