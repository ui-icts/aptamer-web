import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('files/job-list', 'Integration | Component | files/job list', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });
  this.set('jobs', {});
  this.render(hbs`{{files/job-list orderedJobs=jobs}}`);

  assert.equal(this.$().text().trim(), '');

});
