import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  edgeType: DS.attr('string', {defaultValue: 'both'}),
  seed: DS.attr('boolean', {defaultValue: false}),
  maxEditDistance: DS.attr('number', { defaultValue: 3}),
  maxTreeDistance: DS.attr('number', { defaultValue: 3}),

  file: DS.belongsTo(),

  commandLinePreview: Ember.computed('edgeType','seed','maxEditDistance','maxTreeDistance', function() {
    let args = ["-t", this.get('edgeType')];

    if ( this.get('maxEditDistance') > 0 ) {
      args.push("-e");
      args.push(this.get('maxEditDistance'));
    }

    if ( this.get('maxTreeDistance') > 0 ) {
      args.push("-d");
      args.push(this.get('maxTreeDistance'));
    }

    if ( this.get('seed') ) {
      args.push("--seed");
    }

    return args.join(' ');
  })
});
