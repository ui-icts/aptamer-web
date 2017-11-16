import { moduleFor, test } from 'ember-qunit';

moduleFor('route:files', 'Unit | Route | files', {
  // Specify the other units that are required for this test.
  needs: ['service:session', 'service:job-control', 'service:file-contents']
});

test('it exists', function(assert) {
  let route = this.subject();
  assert.ok(route);
});
