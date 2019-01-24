import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, find } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | structure file list item', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function(assert) {

    this.set('filesStub', [
      'file1','file2'
    ]);
    // Template block usage:
    await render(hbs`
      {{#structure-file-list-item files=filesStub as |sf|}}
        {{sf}}
      {{/structure-file-list-item}}
    `);

    assert.notEqual(find('*').textContent.trim(), 'template block text');
  });
});
