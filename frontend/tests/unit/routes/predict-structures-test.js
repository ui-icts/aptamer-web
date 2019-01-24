import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Route | predict structures', function(hooks) {
  setupTest(hooks);

  test('it exists', function(assert) {
    let route = this.owner.lookup('route:predict-structures');
    assert.ok(route);
  });
});
