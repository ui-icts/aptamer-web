import Component from '@ember/component';

export default Component.extend({
  actions: {
    submitForm() {

      this.get('onSubmit')(this.getProperties('username', 'password'));
    }
  }
});
