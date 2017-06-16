import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('graph-options-form', 'Integration | Component | graph options form', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('noop', function() {})
  this.render(hbs`{{graph-options-form fileRunCommand=noop}}`);

  assert.notEqual(this.$().text().trim(), '');

});
