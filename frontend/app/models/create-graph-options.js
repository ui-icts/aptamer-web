import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  edgeType: DS.attr('string', {defaultValue: 'both'}),
  seed: DS.attr('boolean', {defaultValue: false}),
  maxEditDistance: DS.attr('number', { defaultValue: 3}),
  maxTreeDistance: DS.attr('number', { defaultValue: 3}),

  file: DS.belongsTo(),

  commandLinePreview: Ember.computed('edgeType','seed','maxEditDistance','maxTreeDistance', function() {
    return `-t ${this.get('edgeType')} -e ${this.get('maxEditDistance')} -d ${this.get('maxTreeDistance')} --seed ${this.get('seed')}`
  })
});
