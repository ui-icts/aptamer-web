import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('upload-with-progress', 'Integration | Component | upload with progress', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('noop', function() {});
  this.render(hbs`{{upload-with-progress url='/test' onUpload=(action noop)}}`);

  assert.equal(this.$().text().trim(), 'Drop files here to upload');

});
