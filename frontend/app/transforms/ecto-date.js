import DS from 'ember-data';
import moment from 'moment';

export default DS.Transform.extend({
  deserialize(serialized) {
    if ( serialized ) {
      let result = moment.utc(serialized, moment.ISO_8601);
      if (moment.isMoment(result) & result.isValid()) {
        result.local();
        return result;
      }

      return null;

    } else {
      return serialized;
    }
  },

  serialize(deserialized) {
    if (moment.isMoment(deserialized)) {
      return deserialized.toISOString();
    } else {
      return null;
    }
  }
});
