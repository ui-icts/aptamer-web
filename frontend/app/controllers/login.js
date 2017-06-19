import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    doLogin({username, password}) {
      console.log("USERNAME", username);
      console.log("PASSWORD", password);
      this.get('session').authenticate('authenticator:aptamer', username, password)
        .catch( (_reason) => {
          this.set('loginError', "Unable to log in");
        })
        .then( () => {
          this.transitionToRoute('files');
        });
    },

    createAccount({email, name, password}) {

      let params = {
        registration: {
          email,
          name,
          password
        }
      };
      return Ember.$.ajax({
          url: '/register',
          method: 'POST',
          data: JSON.stringify(params),
          dataType: 'json',
          contentType: 'application/json'

      }).catch( () => {
        this.set('signupError', 'Unable to create an account at this time.');

      }).then( () => {
        return this.get('session').authenticate( 'authenticator:aptamer',email,password);

      }).catch( () => {
        this.set('signupError', 'Thank you, please login on the left');

      }).then( () => this.transitionToRoute('files') );



    }
  }
});
