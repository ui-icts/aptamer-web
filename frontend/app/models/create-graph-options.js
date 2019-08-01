import { computed } from '@ember/object';
import DS from 'ember-data';

export default DS.Model.extend({
  edgeType: DS.attr('string', {defaultValue: 'both'}),
  seed: DS.attr('boolean', {defaultValue: false}),
  maxEditDistance: DS.attr('distance', { defaultValue: 3}),
  maxTreeDistance: DS.attr('distance', { defaultValue: 0}),
  batchSize: DS.attr('number', {defaultValue: 10000}),
  spawn: DS.attr('boolean', {defaultValue: true}),
  file: DS.belongsTo(),

  commandLinePreview: computed('edgeType','seed','maxEditDistance','maxTreeDistance','batchSize','spawn', function() {
    let args = ["-t", this.edgeType];

    if ( this.maxEditDistance < 11 ) {
      args.push("-e");
      args.push(this.maxEditDistance);
    }

    if ( this.maxTreeDistance < 11 ) {
      args.push("-d");
      args.push(this.maxTreeDistance);
    }

    args.push("-b");
    args.push(this.batchSize);

    if ( this.spawn ) {
      args.push("--spawn");
    }

    if ( this.seed ) {
      args.push("--seed");
    }

    return args.join(' ');
  })
});
