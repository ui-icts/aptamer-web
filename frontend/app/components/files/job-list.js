import Ember from 'ember';

function byInserted(job1, job2) {
  return job2.get('insertedAt') - job1.get('insertedAt');
}

export default Ember.Component.extend({

  orderedJobs: Ember.computed.sort('jobs',byInserted),

});
