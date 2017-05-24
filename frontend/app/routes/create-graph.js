import Ember from 'ember';
import CreateGraphOptions from '../models/create-graph-options';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import fetch from 'fetch';

let state = Ember.Object.create({
  structureFiles: [],
});

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  async model() {
    let response = await fetch('/files/structure').then( response => response.json() );
    console.log("Response",response);
    state.set('structureFiles', response.files);
    return state;
  },

  actions: {
    fileUploaded(file, uploadResponse, evt) {
      state.get('structureFiles').pushObject(uploadResponse.file);
    },
  }

});
