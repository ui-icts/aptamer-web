import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';


export default Ember.Route.extend(AuthenticatedRouteMixin, {
  model() {
    return this.get('store').findAll('file');
  },

  actions: {
    fileUploaded(_file, uploadResponse, _evt) {
      this.get('store').pushPayload(uploadResponse);
      this.refresh();
    },
  }

});
