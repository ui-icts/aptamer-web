import Ember from 'ember';
const { isBlank } = Ember;

export default Ember.Component.extend({

  invalid: false,

  resetValidations() {

    this.set('errorMessage', '');
    this.set('nameError', false);
    this.set('emailError', false);
    this.set('passwordError', false);
    this.set('confirmPasswordError', false);
    this.set('invalid', false);
  },

  actions: {
    createAccountClick() {
    
      this.resetValidations();

      let params = this.getProperties('name','email','password','confirmPassword')

      if ( isBlank(params.name) ) {
        this.set('nameError', true);
        this.set('invalid', true);
      }

      if ( isBlank(params.email) ) {
        this.set('emailError', true);
        this.set('invalid', true);
      }

      if ( isBlank(params.password) ) {
        this.set('passwordError', true);
        this.set('invalid', true);
      }

      if ( isBlank(params.confirmPassword) ) {
        this.set('confirmPasswordError', true);
        this.set('invalid', true);
      }

      if ( this.get('invalid') ) {
        this.set('errorMessage', 'Please fill out all required fields');

      } else {
        this.get('createAccount')(params);
      }
    },
  }
});
