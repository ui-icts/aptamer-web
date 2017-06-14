import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('predict-structures-input-item', 'Integration | Component | predict structures input item', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{predict-structures-input-item}}`);

  assert.notEqual(this.$().text().trim(), '');

});
