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
    this.set('createGraphOptions', file.get('createGraphOptions') );

  }).drop(),

});
