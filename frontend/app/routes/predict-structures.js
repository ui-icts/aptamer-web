import Ember from 'ember';

export default Ember.Route.extend({
  actions: {
    fileUploaded(file, uploadResponse, evt) {
      this.get('store').pushPayload(uploadResponse);
      this.refresh();
    }

  }

});
