import Component from '@ember/component';

export default Component.extend({

  init() {
    this._super(...arguments);
    this.nums = [1,2,3,4,5,6,7,8,9,10];
  },

  currentValue: undefined,

  actions: {
    selectValue(num) {
      this.set('currentValue', num);
      this.onChange(num);
    }
  }

});
