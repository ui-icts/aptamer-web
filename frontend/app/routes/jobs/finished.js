import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.get('store').find('job', params.job_id);
  },
});
