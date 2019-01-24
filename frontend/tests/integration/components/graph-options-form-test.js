import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, find } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | graph options form', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function(assert) {

    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });

    this.set('noop', function() {})
    this.set('stubbedOptionsObject', {
      maxEditDistance: 1,
      maxTreeDistance: 1
    })
    await render(hbs`{{graph-options-form fileRunCommand=noop optionsObject=stubbedOptionsObject}}`);

    assert.notEqual(find('*').textContent.trim(), '');

  });
});
