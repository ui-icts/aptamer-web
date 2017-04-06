import Ember from 'ember';

const UploadJob = Ember.Object.extend({ });

function fileId(file) {
  return `${file.name}-${file.lastModified}-${file.size}`;
}

export default Ember.Component.extend({

  uploadJobs: [],

  actions: {
    addedFile(file) {
      console.log("Added file", arguments);
      let fileObj = UploadJob.create({
        id: fileId(file),
        fileName: file.name,
        percentComplete: 0
      });

      this.get('uploadJobs').pushObject(fileObj);
    },

    successFile(x) {
      console.log("Success File", arguments);
    },

    completeFile(file) {
      let id = fileId(file);

      let fileObj = this.get('uploadJobs').findBy('id', id);
      if (fileObj) {
        this.get('uploadJobs').removeObject(fileObj);
      }

    },

    errorFile(x) {
      console.log("Error File", arguments);
    },

    progressFile(file, percent) {
      let id = fileId(file);

      let fileObj = this.get('uploadJobs').findBy('id', id);
      if (fileObj) {
        fileObj.set('percentComplete', percent);
      }
    }
  }
});
