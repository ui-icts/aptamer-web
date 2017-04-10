import { Factory, association } from 'ember-cli-mirage';

export default Factory.extend({
  bobby() {
    return "Bobby";
  },

  generatedAt() {
    return new Date();
  },

  file: association()
});
