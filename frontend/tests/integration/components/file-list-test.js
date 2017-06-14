import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

moduleForComponent('file-list', 'Integration | Component | file list', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('filesStub', [
    Ember.Object.create({fileName: 'file1'}),
    Ember.Object.create({fileName: 'file2'}),
  ]);

  // Template block usage:
  this.render(hbs`
    {{#file-list files=filesStub as |sf|}}
      {{sf.fileName}}
    {{/file-list}}
  `);

  assert.notEqual(this.$().text().trim(), 'template block text');
});
