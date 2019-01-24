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

  init() {
    this._super(...arguments);
    //Ember docs claim that simple DS.Store errors are set when the API returns
    //an error. However, this only works in certain specific situations that don't
    //include ours, so we'll just do it ourselves.
    //See https://stackoverflow.com/a/36636638
    this.status = {
      error: false,
      errorMessage: null
    };
  },

  ready() {
    let createGraphOptions = this.createGraphOptions,
        predictStructureOptions = this.predictStructureOptions;

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
