import DS from 'ember-data';
import ENV from 'aptamer/config/environment';
var opts = {};

if ( ENV.environment === 'production' ) {
  opts['namespace'] = ENV.rootURL;
}

export default DS.JSONAPIAdapter.extend(opts);
