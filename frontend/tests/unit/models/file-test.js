import { moduleForModel, test } from 'ember-qunit';

moduleForModel('file', 'Unit | Model | file', {
  // Specify the other units that are required for this test.
  needs: ['model:result', 'model:job', 'model:create-graph-options', 'model:predict-structure-options']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
