import DS from 'ember-data';
import ENV from 'aptamer/config/environment';
var opts = {};

if ( ENV.environment === 'production' ) {
  opts['namespace'] = '/aptamer2';
}

export default DS.JSONAPIAdapter.extend(opts);
