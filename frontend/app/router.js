import EmberRouter from '@ember/routing/router';
import config from './config/environment';

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('files', { path: '/'}, function() {
    this.route('view', { path: '/files/:file_id'});
  });
  this.route('login');

  this.route('jobs', function() {
    this.route('show',{path: '/active/:job_id'});
    this.route('finished', {path: '/finished/:job_id'});
  });
});

export default Router;
