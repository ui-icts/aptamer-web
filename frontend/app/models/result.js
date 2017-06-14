import DS from 'ember-data';

export default DS.Model.extend({
  generatedAt: DS.attr('date'),
  resultNumber: DS.attr('number'),
  commandLine: DS.attr('string'),
  programVersion: DS.attr('string'),
  status: DS.attr('string'),
  file: DS.belongsTo(),
  generatedFiles: DS.hasMany('file', { inverse: 'generatedBy' } )
});
