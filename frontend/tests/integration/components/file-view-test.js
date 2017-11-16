import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('file-view', 'Integration | Component | file view', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('noop', function() {});
  this.set('jobs', {});
  this.render(hbs`{{file-view fileRunCommand=(action noop) jobs=jobs}}`);
  assert.notEqual(this.$().text().trim(), '');

});
