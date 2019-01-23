import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Route.extend(AuthenticatedRouteMixin, {

  session: service('session'),
  jobControl: service('job-control'),
  fileContents: service('file-contents'),

  afterModel() {
    this.get('jobControl').connect();
    this.get('fileContents').connect();
  }

});
