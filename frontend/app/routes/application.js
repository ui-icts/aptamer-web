import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Route.extend(ApplicationRouteMixin, {

  session: service('session'),
  currentUser: service(),

  beforeModel() {
    this._loadCurrentUser();
  },

  sessionAuthenticated() {
    this._super(...arguments);
    this._loadCurrentUser();
  },

  setupController(controller) {
    controller.set('session', this.session );
    controller.set('currentUser', this.currentUser );
  },

  _loadCurrentUser() {
    return this.currentUser
      .load()
      .catch(() => this.session.invalidate());
  },

});

