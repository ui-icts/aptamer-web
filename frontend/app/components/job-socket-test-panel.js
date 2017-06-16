import Ember from 'ember';

export default Ember.Component.extend({

  jobControl: Ember.inject.service('job-control'),

  jobText: 'Test1',
  messages: Ember.computed('jobControl.messages[]', function() {
    return this.get('jobControl.messages');
  }),

  show: false,

  actions: {
    showHide() {
      this.toggleProperty('show');
    },

    start() {
      this.get('jobControl').connect();
    },

    reset() {
      this.get('jobControl').reset();
    },

    startJob() {
      this.get('jobControl').startJob(this.get('jobText'));
    },
  }
});
