import Ember from 'ember';
import CreateGraphOptions from '../models/create-graph-options';

let files = [{
  id: 'final_rd12_struct.fa - 1',
  fileName: 'Final_Rd12_struct.fa',
  uploadedOn: '2017-03-25T08:15:30-05:00'
}, {
  id: 'final_rd12_struct.fa - 2',
  fileName: 'Final_Rd12_struct.fa',
  uploadedOn: '2017-04-01T08:15:30-05:00'
}];


export default Ember.Route.extend({
  model() {
    return Ember.Object.create({
      options: CreateGraphOptions.create(),
      structureFiles: files
    });
  }

});
