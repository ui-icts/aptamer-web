import $ from 'jquery';
import { bind } from '@ember/runloop';
import { inject as service } from '@ember/service';
import Controller from '@ember/controller';

export default Controller.extend({
  session: service('session'),

  actions: {
    doLogin({username, password}) {
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
      return $.ajax({
          url: '/register',
          method: 'POST',
          data: JSON.stringify(params),
          dataType: 'json',
          contentType: 'application/json'

      }).catch( bind(this, () => {
        this.set('signupError', 'Unable to create an account at this time.');

      }) ).then( bind(this, () => {
        return this.get('session').authenticate( 'authenticator:aptamer',email,password);

      }) ).catch( bind(this, () => {
        this.set('signupError', 'Thank you, please login on the left');

      }) ).then( bind(this, () => this.transitionToRoute('files')) );



    }
  }
});
