import { computed } from '@ember/object';
import DS from 'ember-data';
import _ from 'lodash';

export default DS.Model.extend({
  status: DS.attr('string'),
  output: DS.attr('string'),
  insertedAt: DS.attr('ecto-date'),

  file: DS.belongsTo( {inverse: 'jobs'}),
  createGraphOptions: DS.belongsTo('create-graph-options'),
  predictStructureOptions: DS.belongsTo('predict-structure-options'),

  outputLines: computed('output', function() {
    return _.split( this.get('output'), '\n' );
  }),
});
