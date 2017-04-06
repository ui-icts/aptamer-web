import Ember from 'ember';
import CreateGraphOptions from '../models/create-graph-options';

export default Ember.Route.extend({
  model() {
    return CreateGraphOptions.create();
  }

});
