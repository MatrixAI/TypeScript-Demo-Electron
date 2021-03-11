import { createApp } from 'vue';
import configFromQueryParams from '@/renderer/config';
import createRouter from '@/renderer/router';
import store from '@/renderer/store';
import App from '@/renderer/App.vue';
import router from '@/renderer/router';
import store from '@/renderer/store';
import Antd from 'ant-design-vue';
import 'ant-design-vue/dist/antd.css';
import '@/renderer/assets/index.css';

createApp(App)
  .use(Antd)
  .use(store)
  .use(router)
  .mount('#app');
