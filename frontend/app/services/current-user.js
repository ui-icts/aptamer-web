import Ember from 'ember';

export default Ember.Service.extend({
  session: Ember.inject.service('session'),
  store: Ember.inject.service(),

  load() {
    if (this.get('session.isAuthenticated')) {
      return this.get('store').queryRecord('user', { me: true })
        .catch((error) => {
          console.log(error);
        })
        .then((user) => {
          this.set('user', user);
        });
    } else {
      return Ember.RSVP.resolve();
    }
  }
});
