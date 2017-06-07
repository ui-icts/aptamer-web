import Ember from 'ember';

export default Ember.Route.extend({

  model() {
    return this.get('store').findAll('file', {include: 'jobs,createGraphOptions'});
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

    async startProcessFile(file, options) {

      let job = this.get('store').createRecord('job', {
        file: file,
        status: 'ready'
      });

      if ( options ) {
        try {
          options.set('file', file);
          let savedOptions = await options.save();
          job.set('createGraphOptions', savedOptions)
        } catch(e) {
          job.destroy();
          return;
        }
      }

      return job.save();

    },
  }
});
