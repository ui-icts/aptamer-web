import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import {
  fillIn,
  click,
  render,
  find,
  settled
} from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import {
  assertionInjector,
  assertionCleanup
} from '../../assertions';

async function _fillInput(placeholder, value) {
  let input = this.element.querySelector(`input[placeholder="${placeholder}"]`);
  await fillIn(input, value)
}

module('Integration | Component | signup form', function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function() {
    this.fillInput = _fillInput.bind(this);
    assertionInjector(this);
  });

  hooks.afterEach(function() {
    assertionCleanup(this);
  });

  test('it renders', async function(assert) {

    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });

    await render(hbs`{{signup-form}}`);

    assert.notEqual(find('*').textContent.trim(), '');

  });



  test('invokes action with new account params', async function(assert) {


    assert.expect(3);

    this.set('createCallback', function(params) {
      assert.equal(params.name, 'Bob');
      assert.equal(params.email, 'bob@example.com');
      assert.equal(params.password, 'welcome');
    });

    await render(hbs`{{signup-form createAccount=(action createCallback)}}`);

    await this.fillInput('Name','Bob');
    await this.fillInput('Email','bob@example.com');
    await this.fillInput('Password','welcome');
    await this.fillInput('Confirm Password','welcome');

    await settled;
    await click('#createAccount');

  });

  test('validates sign up params', async function(assert) {
    let called = false;
    this.set('callback', function() {
      called = true;
    });

    await render(hbs`{{signup-form createAccount=(action callback)}}`);
    await click('#createAccount');

    assert.fieldError('Name');
    assert.fieldError('Email');
    assert.fieldError('Password');
    assert.fieldError('Confirm Password');

    assert.equal(false, called, 'Callback invoked');
  });
});
