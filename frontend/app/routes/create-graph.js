import Ember from 'ember';
import CreateGraphOptions from '../models/create-graph-options';

export default Ember.Route.extend({
  model() {
    return CreateGraphOptions.create();
  },

  actions: {
    addedFile(x) {
      console.log("Added file", arguments);
    },

    successFile(x) {
      console.log("Success File", arguments);
    },

    completeFile(x) {
      console.log("Complete FIle", arguments);

    },

    errorFile(x) {
      console.log("Error File", arguments);
    }
  }
});
