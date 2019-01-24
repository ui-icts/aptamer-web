import { computed } from '@ember/object';
import Component from '@ember/component';
import _ from 'lodash';
import ENV from 'aptamer/config/environment';

// eslint-disable-next-line no-unused-vars
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

export default Component.extend({

  downloadHost: computed(function() {
    if ( ENV['aptamer-results-host'] ) {
      return ENV['aptamer-results-host'];
    } else {
      return '';
    }
  }),

  orderedJobs: computed('jobs.[]', function() {
    let jobs = this.jobs.toArray();
    return _(jobs)
      .sort(momentSort('insertedAt'))
      .value();

  }),

});
