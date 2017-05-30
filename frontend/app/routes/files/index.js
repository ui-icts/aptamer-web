import Ember from 'ember';

export default Ember.Route.extend({

  model() {
    return this.get('store').findAll('file', {include: 'jobs'});
  },

  actions: {
    fileUploaded(uploadResponse) {
      this.get('store').pushPayload(uploadResponse);
      this.refresh();
    },

    changeFileType(file,newType) {
      file.set('fileType', newType);
      return file.save();
    },

    async startProcessFile(file) {
      let job = await Ember.$.ajax('/jobs', {
        type: "POST", 
        data: {fileId: file.get('id')}
      });

      this.get('store').pushPayload(job);

    },
  }
});
