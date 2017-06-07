import DS from 'ember-data';

export default DS.Model.extend({
  status: DS.attr('string'),
  file: DS.belongsTo( {inverse: 'jobs'}),
  createGraphOptions: DS.belongsTo('create-graph-options'),
});
