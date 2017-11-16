import { moduleFor, test } from 'ember-qunit';

moduleFor('route:files/view', 'Unit | Route | files/view', {
  // Specify the other units that are required for this test.
  needs: ['service:fileContents']
});

test('it exists', function(assert) {
  let route = this.subject();
  assert.ok(route);
});
