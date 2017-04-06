import Ember from 'ember';

export default Ember.Route.extend({
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
