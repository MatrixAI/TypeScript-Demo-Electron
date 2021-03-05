import Library from '@/lib/Library';

declare global {
  namespace NodeJS {
    interface Global {
      projectDir: string;
      testDir: string;
    }
  }
}

describe('Library class', () => {
  let library: Library | null;

  beforeAll(async (done) => {
    library = new Library('some param');
    done();
  });

  afterAll(() => {
    library = null;
  });

  test('some arbitrary test', () => {
    expect(library?.someParam).toEqual('some param');
  });
});
