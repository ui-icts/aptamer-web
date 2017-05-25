import Ember from 'ember';

export default Ember.Component.extend({

  fileSortString: ['uploadedOn:desc'],

  filteredFiles: Ember.computed('files.[]','filter',function() {
    let filterValue = this.get('filter'),
        files = this.get('files');

    if ( Ember.isBlank( filterValue ) || filterValue === 'all' ) {
      return files;
    } else if ( filterValue === 'unknown' ) {
      return files.filterBy('fileType', 'UNKNOWN');
    } else {
      return files.filterBy('fileType',filterValue);
    }
  }),


  filesByUploadDate: Ember.computed.sort('filteredFiles', 'fileSortString'),


});
