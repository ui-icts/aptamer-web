import Ember from 'ember';

export default Ember.Route.extend({

  session: Ember.inject.service('session'),

  setupController(controller) {
    controller.set('session', this.get('session') );
  },

  actions: {
    doLogin(username, password) {
      this.get('session').authenticate('authenticator:stub', username, password).catch( (_reason) => {
      
      });
    },

    createAccount() {
    }
  }
});
