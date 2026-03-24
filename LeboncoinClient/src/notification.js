import { reactive } from 'vue';

export const notificationState = reactive({
  show: false,
  message: ''
});

export function showSuccess(msg) {
  notificationState.message = msg;
  notificationState.show = true;
  
  setTimeout(() => {
    notificationState.show = false;
  }, 5000);
}