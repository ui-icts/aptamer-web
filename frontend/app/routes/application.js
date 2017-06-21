import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {

  session: Ember.inject.service('session'),
  currentUser: Ember.inject.service(),

  beforeModel() {
    this._loadCurrentUser();
  },

  sessionAuthenticated() {
    this._super(...arguments);
    this._loadCurrentUser();
  },

  setupController(controller) {
    controller.set('session', this.get('session') );
    controller.set('currentUser', this.get('currentUser') );
  },

  _loadCurrentUser() {
    return this.get('currentUser')
      .load()
      .catch(() => this.get('session').invalidate());
  },

});

