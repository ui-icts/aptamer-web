import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';

export default Route.extend({
  jobControl: service(),

  beforeModel() {
    let jc = this.jobControl;
    if ( !jc.get('isHealthy') ) {
      jc.connect();
    }
  },

  model(params) {
    return this.store.find('job', params.job_id);
  },

  afterModel(job) {
    let jc = this.jobControl;
    jc.captureOutput(job.get('id'));
  },

   resetController(_controller, _isExiting, _transition) {
     let jc = this.jobControl;
     jc.stopCurrentCapture();
     // if (isExiting) {
     //     controller.set('page', 1);
     // }
   }
});
