import main from '@/bin/typescript-demo-lib';

describe('main', () => {
  test('main takes synthetic parameters', () => {
    // jest can also "spy on" the console object
    // and then you can test on stdout
    expect(main(['1'])).toEqual(0);
  });
});
