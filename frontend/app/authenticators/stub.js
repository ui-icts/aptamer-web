import Ember from 'ember';
import Base from 'ember-simple-auth/authenticators/base';

const { RSVP } = Ember;

export default Base.extend({
  authenticate() {
    return RSVP.resolve();
  },

  restore(_data) {
    return RSVP.resolve();
  },

});
