import Route from '@ember/routing/route';
import { uuid } from 'ember-cli-uuid';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Route.extend(AuthenticatedRouteMixin, {

  model() {
    return this.store.findAll('file', {include: 'jobs,createGraphOptions'});
  },

  actions: {
    fileUploaded(uploadResponse) {
      this.store.pushPayload(uploadResponse);
      this.refresh();
    },

    deleteFile(file) {
      file.deleteRecord();
      return file.save().catch(
        retry(3)
      );

      function retry(retries) {
        return file.save().catch(function(_reason) {

          if(retries-- > 0) {
            return retry(retries)
          }
          //Failed too many times; set status to error = true to show user
          file.set('status.error', true)
          return file.set('status.errorMessage', "Failed to delete file")
        })
      }
    },

    clearError(file) {
      file.set('status.error', false)
      return file.set('status.errorMessage', '')
    },

    changeFileType(file,newType) {
      file.set('fileType', newType);
      return file.save();
    },

    async startProcessFile(file, options) {

      let job = this.store.createRecord('job', {
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
