import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';
import DS from 'ember-data';

export default DS.Model.extend({
  runMfold: DS.attr('boolean', { defaultValue: false }),
  viennaVersion: DS.attr('number', { defaultValue: 2 }),
  prefix: DS.attr('string', { defaultValue: '' }),
  suffix: DS.attr('string', { defaultValue: '' }),
  passOptions: DS.attr('string'),
  file: DS.belongsTo(),

  commandLinePreview: computed('runMfold','viennaVersion','prefix','suffix','passOptions', function() {
    let args = [];
    if ( this.runMfold ) {
      args.push('--run_mfold');
    } else {
      args.push('-v');
      args.push( this.viennaVersion );
    }

    if ( !isBlank(this.prefix) ) {
      args.push('--prefix');
      args.push( `"${this.prefix}"` );
    }

    if ( !isBlank(this.suffix) ) {
      args.push('--suffix');
      args.push( `"${this.suffix}"` );
    }

    if ( !isBlank(this.passOptions) ) {
      args.push('--pass_options');
      args.push( this.passOptions );
    }

    return args.join(' ');
  }),

});
