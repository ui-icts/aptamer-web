import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';

export default Route.extend({
  fileContents: service(),

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
