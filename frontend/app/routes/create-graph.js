import Ember from 'ember';
import CreateGraphOptions from '../models/create-graph-options';

export default Ember.Route.extend({
  model() {
    return this.get('store').findAll('structure-file').then((files) => {
      return Ember.Object.create({
        options: CreateGraphOptions.create(),
        structureFiles: files
      });
    });
  }

});
