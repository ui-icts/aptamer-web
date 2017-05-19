import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {

  session: Ember.inject.service('session'),

  setupController(controller) {
    console.log("setupController", controller);
    controller.set('session', this.get('session') );
  }
});

