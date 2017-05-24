import Ember from 'ember';

const UploadJob = Ember.Object.extend({ });

function fileId(file) {
  return `${file.name}-${file.lastModified}-${file.size}`;
}

export default Ember.Component.extend({

  uploadJobs: [],

  actions: {
    addedFile(file) {
      let fileObj = UploadJob.create({
        id: fileId(file),
        fileName: file.name,
        percentComplete: 0
      });

      this.get('uploadJobs').pushObject(fileObj);
    },

    successFile(file,responseObject,_evt) {
      this.get('onUpload')(responseObject);
    },

    completeFile(file) {
      let id = fileId(file);

      let fileObj = this.get('uploadJobs').findBy('id', id);
      if (fileObj) {
        this.get('uploadJobs').removeObject(fileObj);
      }

    },

    errorFile(_x) {
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
