import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {

  session: Ember.inject.service('session'),
  jobControl: Ember.inject.service('job-control'),
  fileContents: Ember.inject.service('file-contents'),

  afterModel() {
    this.get('jobControl').connect();
    this.get('fileContents').connect();
  }

});
