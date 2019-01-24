import { inject as service } from '@ember/service';
import Component from '@ember/component';
import EmberObject from '@ember/object';
import $ from 'jquery';

const UploadJob = EmberObject.extend({ });

function fileId(file) {
  return `${file.name}-${file.lastModified}-${file.size}`;
}

export default Component.extend({

  session: service(),

  init() {
    this._super(...arguments);
    this.uploadJobs = [];
    
    //TODO: This header name here might be wrong
    //OR ... I might need to add Bearer in front of the token
    //https://github.com/simplabs/ember-simple-auth/blob/master/addon/authorizers/oauth2-bearer.js
    let { access_token } = this.get('session.data.authenticated');
    let obj = {
      "Authorization": access_token
    };
    this.set('dropzoneHeaders', obj);

  },

  actions: {
    addedFile(file) {
      let fileObj = UploadJob.create({
        id: fileId(file),
        fileName: file.name,
        percentComplete: 0
      });

      this.uploadJobs.pushObject(fileObj);
    },

    successFile(_file,responseText,_evt) {

      // With mirage I get back a json object
      // but otherwise I have to parse the string

      if ( typeof responseText === 'string' ) {
        let json = $.parseJSON(responseText);
        this.onUpload(json);
      } else {
        this.onUpload(responseText);
      }
    },

    completeFile(file) {
      let id = fileId(file);

      let fileObj = this.uploadJobs.findBy('id', id);
      if (fileObj) {
        this.uploadJobs.removeObject(fileObj);
      }

    },

    errorFile(_x) {
    },

    progressFile(file, percent) {
      let id = fileId(file);

      let fileObj = this.uploadJobs.findBy('id', id);
      if (fileObj) {
        fileObj.set('percentComplete', percent);
      }
    }
  }
});
