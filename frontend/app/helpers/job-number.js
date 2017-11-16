import Ember from 'ember';

export function jobNumber([value,..._rest]/*, hash*/) {
  let number = value + 1;
  return `#${number}`;
}

export default Ember.Helper.helper(jobNumber);
