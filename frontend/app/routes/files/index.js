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

    startProcessFile(file) {
      let job = this.get('store').createRecord('job', {
        file: file,
        status: 'ready'
      });

      return job.save();

    },
  }
});
