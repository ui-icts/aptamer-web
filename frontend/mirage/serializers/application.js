import { JSONAPISerializer } from 'ember-cli-mirage';
//ActiveModelSerializer,Serializer 
export default JSONAPISerializer.extend({
  include: function(_request) {
    return ['jobs'];
  },

  // keyForRelationship(modelName) {
  //   console.log("keyForRelationship", modelName);
  //   if ( modelName === 'job' ) {
  //     return 'jobs';
  //   }
  //
  //   return modelName;
  // }
});
