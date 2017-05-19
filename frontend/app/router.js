import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('create-graph', {path: '/'});
  this.route('predict-structures');
  this.route('login');
});

export default Router;
