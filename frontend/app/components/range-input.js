import Ember from 'ember';

export default Ember.Component.extend({
  nums: [1,2,3,4,5,6,7,8,9,10],

  currentValue: undefined,

  actions: {
    selectValue(num) {
      this.set('currentValue', num);
      this.get('onChange')(num);
      console.log("Clicked on value", num);
    }
  }

});
