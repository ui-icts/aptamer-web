import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

import { run } from '@ember/runloop';

module('Unit | Model | create graph options', function(hooks) {
  setupTest(hooks);

  test('it exists', function(assert) {
    let model = run(() => this.owner.lookup('service:store').createRecord('create-graph-options'));
    // let store = this.store();
    assert.ok(!!model);
  });

  test('it can generate a command line with spawn and batch size', function(assert) {

    let model = run(() => this.owner.lookup('service:store').createRecord('create-graph-options'));
    model.set('batchSize', 1001);
    model.set('spawn', true)
    assert.equal( model.get('commandLinePreview'), '-t both -e 3 -d 0 -b 1001 --spawn', "Preview includes batch and spawn options");


  });
});
