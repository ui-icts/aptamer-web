import { Factory, association } from 'ember-cli-mirage';

export default Factory.extend({
  status: 'running',
  file: association()
});
