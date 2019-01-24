import Route from '@ember/routing/route';

export default Route.extend({

  model() {
    return this.store.query('file', {
      filter: {
        filePurpose: 'predict-structures-input'
      }
    });
  },

  actions: {
    fileUploaded(_file, uploadResponse, _evt) {
      this.store.pushPayload(uploadResponse);
      this.refresh();
    }

  }

});
