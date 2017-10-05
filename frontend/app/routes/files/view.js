import Ember from 'ember';

export default Ember.Route.extend({
  fileContents: Ember.inject.service(),

  beforeModel() {
    let fileContents = this.get('fileContents');
    if ( !fileContents.get('isHealthy') ) {
      fileContents.connect();
    }
  },

  model(params) {
    return this.get('store').findRecord('file', params.file_id);
  },

   resetController(_controller, _isExiting, _transition) {
     let fileContents = this.get('fileContents');
     fileContents.stopCurrentCapture();
   }
});
