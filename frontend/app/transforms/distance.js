import DS from 'ember-data';

export default DS.Transform.extend({
  deserialize(serialized) {
    return (serialized == -1) ? 11 : serialized;
  },

  serialize(deserialized) {
    return (deserialized < 11) ? deserialized : -1;
  }
});
