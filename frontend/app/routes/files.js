import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {

  session: Ember.inject.service('session'),

  model() {
    return this.get('store').findAll('file');
  },

  actions: {
    fileUploaded(uploadResponse) {
      console.log("RESPONSE:", uploadResponse);
      this.get('store').pushPayload(uploadResponse);
      this.refresh();
    },
  }
});
