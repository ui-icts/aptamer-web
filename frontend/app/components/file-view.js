import Ember from 'ember';
import moment from 'moment';

export default Ember.Component.extend({
  fileTypes: Ember.inject.service(),
  classNames: ['item'],
  showMore: false,
  processButtonText: 'Process',
  fileName: 'Test File',
  shortDescription: 'Sample text here',

  
  enrichedFile: Ember.computed('file', function() {
    let fileTypes = this.get('fileTypes'),
        file      = this.get('file'),
        fileType  = fileTypes.find( file.get('fileType') );

    return {
      fileName: file.get('fileName'),
      shortDescription: `Uploaded ${moment( file.get('uploadedOn') ).fromNow()}`,
      operationText: fileType.get('operationText')
    };
  }),

  fileTypeOptions: Ember.computed(function() {
    return this.get('fileTypes').list()
  }),

  actions: {
    toggleShowMore() {
      this.toggleProperty('showMore');
    },

    changeFileType(key) {
      console.log("New file type key", key);
    }
  }
});
