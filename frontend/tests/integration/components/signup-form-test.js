import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { assertionInjector } from '../../assertions';

function _fillInput(placeholder, value) {
  let input = this.$(`input[placeholder="${placeholder}"]`);
  input.val(value);
  input.trigger('keyup');
}

function _clickButton(text) {
  let btn = this.$(`button:contains("${text}")`);
  return btn.click();
}

moduleForComponent('signup-form', 'Integration | Component | signup form', {
  integration: true,

  beforeEach() {
    this.fillInput = _fillInput.bind(this);
    this.submit = _clickButton.bind(this);
    assertionInjector(this);
  },


});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{signup-form}}`);

  assert.notEqual(this.$().text().trim(), '');

});



test('invokes action with new account params', function(assert) {


  assert.expect(3);

  this.set('createCallback', function(params) {
    assert.equal(params.name, 'Bob');
    assert.equal(params.email, 'bob@example.com');
    assert.equal(params.password, 'welcome');
  });

  this.render(hbs`{{signup-form createAccount=(action createCallback)}}`);

  this.fillInput('Name','Bob');
  this.fillInput('Email','bob@example.com');
  this.fillInput('Password','welcome');
  this.fillInput('Confirm Password','welcome');

  this.submit("Create Account");

});

test('validates sign up params', function(assert) {
  let called = false;
  this.set('callback', function() {
    called = true;
  });

  this.render(hbs`{{signup-form createAccount=(action callback)}}`);
  this.submit('Create Account');

  assert.fieldError('Name');
  assert.fieldError('Email');
  assert.fieldError('Password');
  assert.fieldError('Confirm Password');

  assert.equal(false, called, 'Callback invoked');
});
