import DS from 'ember-data';

export default DS.Model.extend({
  generatedAt: DS.attr('date'),
  structureFile: DS.belongsTo()
});
