import Ember from 'ember';
import {uuid} from 'ember-cli-uuid';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {

  model() {
    return this.get('store').findAll('file', {include: 'jobs,createGraphOptions'});
  },

  actions: {
    fileUploaded(uploadResponse) {
      this.get('store').pushPayload(uploadResponse);
      this.refresh();
    },

    deleteFile(file) {
      file.deleteRecord();
      console.log(file.get("fileName") + " deleted: " + file.get('isDeleted'))
      return file.save();
    },

    changeFileType(file,newType) {
      file.set('fileType', newType);
      return file.save();
    },

    async startProcessFile(file, options) {

      let job = this.get('store').createRecord('job', {
        id: uuid(),
        file: file,
        status: 'ready'
      });

      if ( options ) {
        try {
          options.set('file', file);
          let savedOptions = await options.save();

          if ( file.get('fileType') === 'structure' ) {
            job.set('createGraphOptions', savedOptions)
          } else {
            job.set('predictStructureOptions', savedOptions);
          }

        } catch(e) {
          job.destroy();
          return;
        }
      }

      return job.save();

    },
  }
});
