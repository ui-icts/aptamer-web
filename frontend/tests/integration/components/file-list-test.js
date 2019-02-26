import EmberObject from '@ember/object';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, find } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | file list', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function(assert) {

    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });

    this.set('filesStub', [
      EmberObject.create({fileName: 'file1'}),
      EmberObject.create({fileName: 'file2'}),
    ]);

    // Template block usage:
    await render(hbs`
      {{#file-list files=filesStub as |sf|}}
        {{sf.fileName}}
      {{/file-list}}
    `);

    assert.notEqual(find('*').textContent.trim(), 'template block text');
  });
});
