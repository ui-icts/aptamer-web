import DS from 'ember-data';
import Ember from 'ember';
import ENV from 'aptamer/config/environment';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

var opts = {
  authorizer: 'authorizer:oauth2'
};

if ( ENV.environment === 'production') {
  //You don't want to set this to just '/' or the 
  //adapter will request things like http://files?include
  if ( !Ember.isBlank(ENV.rootURL) && ENV.rootURL !== '/') {
    opts['namespace'] = ENV.rootURL;
  }
}

export default DS.JSONAPIAdapter.extend(DataAdapterMixin, opts);
