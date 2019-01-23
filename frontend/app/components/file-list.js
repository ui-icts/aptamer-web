import { sort } from '@ember/object/computed';
import { isBlank } from '@ember/utils';
import { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({

  fileSortString: ['uploadedOn:desc'],

  filteredFiles: computed('files.[]','filter',function() {
    let filterValue = this.get('filter'),
        files = this.get('files');

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
