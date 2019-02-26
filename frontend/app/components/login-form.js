import Component from '@ember/component';

export default Component.extend({
  actions: {
    submitForm() {

      this.onSubmit(this.getProperties('username', 'password'));
    }
  }
});
