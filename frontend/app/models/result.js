import DS from 'ember-data';

export default DS.Model.extend({
  generatedAt: DS.attr('date'),
  file: DS.belongsTo()
});
