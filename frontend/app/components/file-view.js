import Ember from 'ember';
import moment from 'moment';

export default Ember.Component.extend({
  fileTypes: Ember.inject.service(),
  classNames: ['item'],
  showMore: false,
  processButtonText: 'Process',
  fileName: 'Test File',
  shortDescription: 'Sample text here',

  runningJobs: Ember.computed('jobs[]', function() {
    return this.get('jobs');
  }),

  fileTypeOptions: Ember.computed(function() {
    return this.get('fileTypes').list()
  }),


  actions: {
    toggleShowMore() {
      this.toggleProperty('showMore');
    },
  }
});
