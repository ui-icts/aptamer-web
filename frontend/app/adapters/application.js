import DS from 'ember-data';
import ENV from 'your-application-name/config/environment';
var opts = {};

if ( ENV.environment === 'production' ) {
  opts['namespace'] = '/aptamer2';
}

export default DS.JSONAPIAdapter.extend(opts);
