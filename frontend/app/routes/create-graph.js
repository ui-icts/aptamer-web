import Route from '@ember/routing/route';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';


export default Route.extend(AuthenticatedRouteMixin, {
  model() {
    return this.store.findAll('file');
  },

  actions: {
    fileUploaded(_file, uploadResponse, _evt) {
      this.store.pushPayload(uploadResponse);
      this.refresh();
    },
  }

});
