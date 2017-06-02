import Ember from 'ember';

export default Ember.Route.extend({
  jobControl: Ember.inject.service(),

  beforeModel() {
    let jc = this.get('jobControl');
    if ( !jc.get('isHealthy') ) {
      jc.connect();
    }
  },

  model(params) {
    return this.get('store').find('job', params.job_id);
  },

  afterModel(job) {
    let jc = this.get('jobControl');
    jc.captureOutput(job.get('id'));
  }
});
