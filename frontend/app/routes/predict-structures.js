import Ember from 'ember';

export default Ember.Route.extend({

  model() {
    return this.get('store').query('file', {
      filter: {
        filePurpose: 'predict-structures-input'
      }
    });
  },

  actions: {
    fileUploaded(_file, uploadResponse, _evt) {
      this.get('store').pushPayload(uploadResponse);
      this.refresh();
    }

  }

});
