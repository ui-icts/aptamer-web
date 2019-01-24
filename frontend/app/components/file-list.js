import { sort } from '@ember/object/computed';
import { isBlank } from '@ember/utils';
import { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({

  init() {
    this._super(...arguments);
    this.fileSortString = ['uploadedOn:desc'];
  },

  filteredFiles: computed('files.[]','filter',function() {
    let filterValue = this.filter,
        files = this.files;

    if ( isBlank( filterValue ) || filterValue === 'all' ) {
      return files;
    } else if ( filterValue === 'unknown' ) {
      return files.filterBy('fileType', 'UNKNOWN');
    } else {
      return files.filterBy('fileType',filterValue);
    }
  }),


  filesByUploadDate: sort('filteredFiles', 'fileSortString'),


});
