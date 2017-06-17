export default function fieldError(context, placeholder, message) {
  message = message || `${placeholder} field should have an error class`;
  let input = context.$(`input[placeholder="${placeholder}"]`);
  let field = input.closest('div.field');
  let actual = field.attr('class').split(' ');
  let expected = [ 'field', 'error' ];
  let result = field.hasClass('error');

  this.pushResult({ result, actual, expected, message});
  // use this.push to add the assertion.
  // see: https://api.qunitjs.com/push/ for more information
}
