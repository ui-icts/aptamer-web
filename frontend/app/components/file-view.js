import { computed } from '@ember/object';
import { filterBy } from '@ember/object/computed';
import { inject as service } from '@ember/service';
import Component from '@ember/component';
import ENV from 'aptamer/config/environment';

export default Component.extend({
  store: service(),

  fileTypes: service(),
  classNames: ['item'],
  showMore: false,
  confirmingDelete: false,
  processButtonText: 'Process',
  fileName: 'Test File',
  shortDescription: 'Sample text here',

  readyJobs: filterBy('jobs', 'status', 'ready'),
  runningJobs: filterBy('jobs', 'status', 'running'),

  fileTypeOptions: computed(function() {
    return this.fileTypes.list();
  }),

  selectedCommand: computed('fileType', function() {
    let ft = this.fileType;
    if ( ft === 'fasta' ) {
      return 'predict_structures';
    } else {
      return 'create_graph';
    }
  }),

  downloadHost: computed(function() {
    if ( ENV['aptamer-results-host'] ) {
      return ENV['aptamer-results-host'];
    } else {
      return '';
    }
  }),

  actions: {
    toggleShowMore() {
      this.toggleProperty('showMore');
    },

    toggleConfirmModal() {
      this.toggleProperty('confirmingDelete');
    },

    errorViewed(file) {
      this.onErrorViewed(file);
    },

    deleteFile(file) {
      this.toggleProperty('confirmingDelete');
      this.onDelete(file);
    },

    selectCommand(newCommand) {
      if ( newCommand === 'predict_structures' ) {
        this.onFileTypeChange('fasta');
      } else {
        this.onFileTypeChange('structure');
      }
    },
  }
});
