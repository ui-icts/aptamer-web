import Ember from 'ember';
import CreateGraphOptions from '../models/create-graph-options';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import fetch from 'fetch';

let state = Ember.Object.create({
  structureFiles: [],
});

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  model() {
    return this.get('store').findAll('file');
  },

  actions: {
    fileUploaded(file, uploadResponse, evt) {
      state.get('structureFiles').pushObject(uploadResponse.file);
    },
  }

});
