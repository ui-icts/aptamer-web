import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submitForm() {

      this.get('onSubmit')(this.getProperties('username', 'password'));
    }
  }
});
