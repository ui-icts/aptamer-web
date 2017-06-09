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
    let file = this.get('file'),
        store = file.get('store'),
        queryParams = {
          filter: {
            forFile: file.get('id')
          }
        };

    let options = yield Ember.RSVP.hash({
      createGraph: store.query('create-graph-options', queryParams),
      predictStructure: store.query('predict-structure-options', queryParams)
    });

    this._initializeOptions('createGraphOptions', 'create-graph-options', options.createGraph, store);
    this._initializeOptions('predictStructureOptions', 'predict-structure-options', options.predictStructure, store);

  }).drop(),

  _initializeOptions(property, modelName, currentOptions, store) {

    let options;

    if ( Ember.isEmpty(currentOptions) ) {
      options = store.createRecord(modelName);
    } else {
      options = currentOptions.get('firstObject');
    }

    this.set(property, options );
  }
});
