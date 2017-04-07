import Ember from 'ember';

export default Ember.Component.extend({
  fileSortString: ['uploadedOn:desc'],
  filesByUploadDate: Ember.computed.sort('files', 'fileSortString')
});
