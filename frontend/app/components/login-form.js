import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submitForm() {

      let { username, password } = this.getProperties('username', 'password');
      this.get('session').authenticate('authenticator:stub', username, password).catch( (reason) => {
        this.set('errorMessage', reason.error || reason );
      });
    }
  }
});
