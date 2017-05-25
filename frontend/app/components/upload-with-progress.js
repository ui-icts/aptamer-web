import Ember from 'ember';
import $ from 'jquery';

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

    successFile(_file,responseText,_evt) {

      // With mirage I get back a json object
      // but otherwise I have to parse the string

      if ( typeof responseText === 'string' ) {
        let json = $.parseJSON(responseText);
        this.get('onUpload')(json);
      } else {
        this.get('onUpload')(responseText);
      }
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
