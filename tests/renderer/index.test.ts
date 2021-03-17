import type { Config } from '@/renderer/config';

import { mount } from '@vue/test-utils';
import App from '@/renderer/App.vue';
import store from '@/renderer/store';
import createRouter from '@/renderer/router';

const config: Config = {
  BASE_PATH: '',
};

const router = createRouter(config);

describe('index', () => {
  test('Test the App', async () => {
    router.push('/');
    await router.isReady();
    const wrapper = mount(App, {
      global: {
        plugins: [store, router],
      },
      props: {
        config: config,
      },
    });
    expect(wrapper.html()).toContain('TypeScript Demo Electron');
  });
});
