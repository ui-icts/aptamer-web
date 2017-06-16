import Ember from 'ember';
import ENV from 'aptamer/config/environment';

Ember.Controller.reopen({
    rootURL: ENV.rootURL,
});

Ember.Component.reopen({
    rootURL: ENV.rootURL,
});

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
    }
  }
})
