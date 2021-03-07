import { createApp } from 'vue';
import App from '@/renderer/App.vue';
import '@/renderer/index.css';

console.log('👋 This message is being logged by "renderer.js", included via webpack');

const app = createApp(App)
app.mount('#root')
