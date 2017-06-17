import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    doLogin(username, password) {
      this.get('session').authenticate('authenticator:stub', username, password).catch( (_reason) => {

      });
    },

    createAccount(params) {

      return Ember.$.ajax({
          url: '/register',
          method: 'POST',
          data: JSON.stringify(params),
          dataType: 'json',
          contentType: 'application/json'

      }).catch( () => {
        this.set('signupError', 'Unable to create an account at this time.');

      }).then( () => {
        return this.get('session').authenticate( 'authenticator:stub',params.email,params.password);

      }).catch( () => {
        this.set('signupError', 'Thank you, please login on the left');

      }).then( () => this.transitionToRoute('files') );



    }
  }
});
