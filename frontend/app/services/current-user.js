import { resolve } from 'rsvp';
import Service, { inject as service } from '@ember/service';

export default Service.extend({
  session: service('session'),
  store: service(),

  load() {
    if (this.get('session.isAuthenticated')) {
      return this.store.queryRecord('user', { me: true })
        .catch((error) => {
          console.log(error);
        })
        .then((user) => {
          this.set('user', user);
        });
    } else {
      return resolve();
    }
  }
});
