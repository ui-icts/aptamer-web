import Ember from 'ember';

export default Ember.Component.extend({
  fileTypes: Ember.inject.service(),
  classNames: ['item'],
  showMore: false,
  processButtonText: 'Process',
  fileName: 'Test File',
  shortDescription: 'Sample text here',

  runningJobs: Ember.computed.filterBy('jobs', 'status', 'running'),

  fileTypeOptions: Ember.computed(function() {
    return this.get('fileTypes').list()
  }),


  actions: {
    toggleShowMore() {
      this.toggleProperty('showMore');
    },
  }
});
