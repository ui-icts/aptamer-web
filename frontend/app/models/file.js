import DS from 'ember-data';

export default DS.Model.extend({
  fileName: DS.attr('string'),
  uploadedOn: DS.attr('date'),

  //Use this to keep track of if it
  //is a structure file or whatever
  filePurpose: DS.attr('string'),

  results: DS.hasMany()
});
