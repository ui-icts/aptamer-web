import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  edgeType: "both",
  seed: false,
  maxEditDistance: 3,
  maxTreeDistance: 3,

  file: DS.belongsTo('file', { inverse: 'createGraphOptions' }),

  commandLinePreview: Ember.computed('edgeType','seed','maxEditDistance','maxTreeDistance', function() {
    return `-t ${this.get('edgeType')} -e ${this.get('maxEditDistance')} -d ${this.get('maxTreeDistance')} --seed ${this.get('seed')}`
  })
});
