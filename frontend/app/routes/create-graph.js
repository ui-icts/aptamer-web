import Ember from 'ember';
import CreateGraphOptions from '../models/create-graph-options';

export default Ember.Route.extend({
  model() {
    return this.get('store').findAll('file').then((files) => {
      return Ember.Object.create({
        options: CreateGraphOptions.create(),
        structureFiles: files
      });
    });
  },

  actions: {
    fileUploaded(file, uploadResponse, evt) {
      this.get('store').pushPayload(uploadResponse);
      this.refresh();
    },

    toggleSidebar: function(id) {
      $(`#${id}`).sidebar('toggle');
    }
  }

});
