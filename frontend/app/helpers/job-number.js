import Ember from 'ember';

export function jobNumber([value,...rest]/*, hash*/) {
  let number = value + 1;
  return `#${number}`;
}

export default Ember.Helper.helper(jobNumber);
