import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('structure-file-list-item', 'Integration | Component | structure file list item', {
  integration: true
});

test('it renders', function(assert) {

  this.set('filesStub', [
    'file1','file2'
  ]);
  // Template block usage:
  this.render(hbs`
    {{#structure-file-list-item files=filesStub as |sf|}}
      {{sf}}
    {{/structure-file-list-item}}
  `);

  assert.notEqual(this.$().text().trim(), 'template block text');
});
