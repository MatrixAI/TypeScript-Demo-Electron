import process from 'process';
import path from 'path';

type Config = {
  BASE_PATH: string;
  TMPDIR: string;
};

const config = {};

config['BASE_PATH'] = path.join(__dirname, 'index.html');
config['TMPDIR'] = process.env.TMPDIR ?? '/tmp';

export default config as Config;

export type { Config };
