import { helper } from '@ember/component/helper';

export function jobNumber([value,..._rest]/*, hash*/) {
  let number = value + 1;
  return `#${number}`;
}

export default helper(jobNumber);
