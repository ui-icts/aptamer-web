import DS from 'ember-data';

export default DS.Model.extend({
  fileName: DS.attr('string'),
  uploadedOn: DS.attr('ecto-date'),

  //Use this to keep track of if it
  //is a structure file or whatever
  fileType: DS.attr('string'),
  jobs: DS.hasMany({async: false}),

  results: DS.hasMany(),
  generatedBy: DS.belongsTo('result' , { inverse: 'generatedFiles' }),

  ready() {
    let createGraphOptions = this.get('createGraphOptions'),
        predictStructureOptions = this.get('predictStructureOptions');

    if ( !createGraphOptions ) {

      createGraphOptions = this.store.createRecord('create-graph-options', {
        file: this
      });


      this.set('createGraphOptions', createGraphOptions );
    }

    if ( !predictStructureOptions ) {

      predictStructureOptions = this.store.createRecord('predict-structure-options', {
        file: this
      });


      this.set('predictStructureOptions', predictStructureOptions );
    }
  }
});
