import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

import { run } from '@ember/runloop';

module('Unit | Model | predict structure options', function(hooks) {
  setupTest(hooks);

  test('it exists', function(assert) {
    let model = run(() => this.owner.lookup('service:store').createRecord('predict-structure-options'));
    // let store = this.store();
    assert.ok(!!model);
  });

  test('it can have commands and flags in passOptions', function(assert) {

    let model = run(() => this.owner.lookup('service:store').createRecord('predict-structure-options'));
    model.set('passOptions', '-flag andValue');

    assert.equal( model.get('commandLinePreview'), '-v 2 --pass_options -flag andValue', "Command line preview shows passthrough options");


  });
});
