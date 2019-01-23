import { computed } from '@ember/object';
import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({

  jobControl: service('job-control'),

  jobText: 'Test1',
  messages: computed('jobControl.messages[]', function() {
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
