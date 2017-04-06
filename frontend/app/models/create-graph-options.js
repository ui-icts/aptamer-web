import Ember from 'ember';

export default Ember.Object.extend({
  edgeType: "both",
  seed: false,
  maxEditDistance: 3,
  maxTreeDistance: 3,

  commandLinePreview: Ember.computed('edgeType','seed','maxEditDistance','maxTreeDistance', function() {
    return `python create_graph.py -t ${this.get('edgeType')} -e ${this.get('maxEditDistance')} -d ${this.get('maxTreeDistance')} --seed ${this.get('seed')}`
  })
});
