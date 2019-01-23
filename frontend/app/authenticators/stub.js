import RSVP from 'rsvp';
import Base from 'ember-simple-auth/authenticators/base';

export default Base.extend({
  authenticate() {
    return RSVP.resolve();
  },

  restore(_data) {
    return RSVP.resolve();
  },

});
