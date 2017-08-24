import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),

  fileTypes: Ember.inject.service(),
  classNames: ['item'],
  showMore: false,
  confirmingDelete: false,
  processButtonText: 'Process',
  fileName: 'Test File',
  shortDescription: 'Sample text here',

  readyJobs: Ember.computed.filterBy('jobs', 'status', 'ready'),
  runningJobs: Ember.computed.filterBy('jobs', 'status', 'running'),

  fileTypeOptions: Ember.computed(function() {
    return this.get('fileTypes').list()
  }),

  selectedCommand: Ember.computed('fileType', function() {
    let ft = this.get('fileType');
    if ( ft === 'fasta' ) {
      return 'predict_structures';
    } else {
      return 'create_graph';
    }
  }),

  actions: {
    toggleShowMore() {
      this.toggleProperty('showMore');
    },

    toggleConfirmModal() {
      this.toggleProperty('confirmingDelete');
    },

    selectCommand(newCommand) {
      if ( newCommand === 'predict_structures' ) {
        this.get('onFileTypeChange')('fasta');
      } else {
        this.get('onFileTypeChange')('structure');
      }
    },
  }
});
