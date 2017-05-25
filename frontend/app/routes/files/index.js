import Ember from 'ember';

export default Ember.Route.extend({

  model() {
    return this.get('store').findAll('file');
  },

  actions: {
    fileUploaded(uploadResponse) {
      this.get('store').pushPayload(uploadResponse);
      this.refresh();
    },

    changeFileType(file,newType) {
      console.log("Change file type", newType);
      file.set('fileType', newType);
      return file.save();
    },
  }
});
