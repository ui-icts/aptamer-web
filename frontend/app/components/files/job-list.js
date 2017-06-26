import Ember from 'ember';
import _ from 'lodash';

function byInserted(job1, job2) {
  return job1.get('insertedAt') - job2.get('insertedAt');
}

function momentSort(field) {
  return function(a,b) {
    let af = a.get(field),
        bf = b.get(field);

    if ( af && bf ) {
      return a.get(field) - b.get(field);
    } else if ( af ) {
      return -1;
    } else {
      return 1;
    }
  }
}

export default Ember.Component.extend({

  orderedJobs: Ember.computed('jobs.[]', function() {
    let jobs = this.get('jobs').toArray();
    return _(jobs)
      .sort(momentSort('insertedAt'))
      .value();

  }),

});
