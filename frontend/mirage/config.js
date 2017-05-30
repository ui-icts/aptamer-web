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

  this.post('/files', ({ files }) => {

    let sf = files.create({
      fileName: "Uploaded File",
      filePurpose: 'create-graph-input',
      uploadedOn: new Date()
    });

    return sf;
  });

  this.post('/jobs', function({ files, jobs}) {
    let attrs = this.normalizedRequestAttrs();
    let file = files.find(attrs.fileId);
    let job = jobs.create({status: 'running', fileId: file.id})
    return job;
  });

}
