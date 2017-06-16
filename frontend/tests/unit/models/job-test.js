import { moduleForModel, test } from 'ember-qunit';

moduleForModel('job', 'Unit | Model | job', {
  // Specify the other units that are required for this test.
  needs: [ 'model:file', 'model:create-graph-options', 'model:predict-structure-options']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
