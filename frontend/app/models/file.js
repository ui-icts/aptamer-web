import DS from 'ember-data';

export default DS.Model.extend({
  fileName: DS.attr('string'),
  uploadedOn: DS.attr('date'),

  //Use this to keep track of if it
  //is a structure file or whatever
  fileType: DS.attr('string'),
  jobs: DS.hasMany({async: false}),

  createGraphOptions: DS.belongsTo('create-graph-options',{ inverse: 'file', async: false}),

  results: DS.hasMany(),
  generatedBy: DS.belongsTo('result' , { inverse: 'generatedFiles' }),

  ready() {
    if ( !!this.get('createGraphOptions') ) {
      return;
    }

    let options = this.store.createRecord('create-graph-options', {
      file: this
    });


    this.set('createGraphOptions', options );
  }
});
