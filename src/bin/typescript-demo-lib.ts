#!/usr/bin/env node

import process from 'process';
import Library from '../lib/Library';
import { v4 as uuidv4 } from 'uuid';

function main(argv = process.argv): number {
  console.log(argv.slice(2));
  const l = new Library('new library');
  console.log(l.someParam);
  console.log(uuidv4());
  process.exitCode = 0;
  return process.exitCode;
}

if (require.main === module) {
  main();
}

export default main;
