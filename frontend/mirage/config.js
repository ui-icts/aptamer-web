export default function() {

  // These comments are here to help you get started. Feel free to delete them.

  /*
    Config (with defaults).

    Note: these only affect routes defined *after* them!
  */

  // this.urlPrefix = '';    // make this `http://localhost:8080`, for example, if your API is on a different server
  // this.namespace = '';    // make this `/api`, for example, if your API is namespaced
  // this.timing = 400;      // delay for each _request, automatically set to 0 during testing

  // this.passthrough("/files");

  this.get('/files');

  this.post('/files', (schema, _request) => {

    let sf = schema.files.create({ 
      fileName: "Uploaded File",
      filePurpose: 'create-graph-input',
      uploadedOn: new Date()
    });

    return sf;
  });

  this.post('/files/fas', (schema,_request) => {
    let sf = schema.files.create({ 
      fileName: "Uploaded File",
      filePurpose: 'predict-structures-input',
      uploadedOn: new Date()
    });

    return sf;
  }, { timing: 4000 });

}
