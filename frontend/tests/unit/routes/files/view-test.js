import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Route | files/view', function(hooks) {
  setupTest(hooks);

  test('it exists', function(assert) {
    let route = this.owner.lookup('route:files/view');
    assert.ok(route);
  });
});
