import Controller from '@ember/controller';
import { uuid } from 'ember-cli-uuid';

export default Controller.extend({
  actions: {
    fileUploaded(uploadResponse) {
      this.store.pushPayload(uploadResponse);
    },

    deleteFile(file) {
      file.deleteRecord();
      return file.save();

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
