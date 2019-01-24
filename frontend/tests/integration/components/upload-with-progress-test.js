import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, find } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | upload with progress', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function(assert) {

    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });

    this.set('noop', function() {});
    await render(hbs`{{upload-with-progress url='/test' onUpload=(action noop)}}`);

    assert.equal(find('*').textContent.trim(), 'Drop files here to upload');

  });
});
