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
    if ( this.get('runMfold') ) {
      args.push('--run_mfold');
    } else {
      args.push('-v');
      args.push( this.get('viennaVersion') );
    }

    if ( !isBlank(this.get('prefix')) ) {
      args.push('--prefix');
      args.push( `"${this.get('prefix')}"` );
    }

    if ( !isBlank(this.get('suffix')) ) {
      args.push('--suffix');
      args.push( `"${this.get('suffix')}"` );
    }

    if ( !isBlank(this.get('passOptions')) ) {
      args.push('--pass_options');
      args.push( this.get('passOptions') );
    }

    return args.join(' ');
  }),

});
