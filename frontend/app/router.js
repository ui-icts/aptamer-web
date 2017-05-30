import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('files', { path: '/'}, function() {
    this.route('view', { path: '/files/:file_id'});
  });
  this.route('login');

  this.route('jobs', function() {
    this.route('show',{path: '/:job_id'});
  });
});

export default Router;
