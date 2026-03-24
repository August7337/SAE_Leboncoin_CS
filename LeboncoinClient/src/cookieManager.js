import { reactive } from 'vue';

const STORAGE_KEY = 'leboncoin_cookie_consent';

const savedConsent = localStorage.getItem(STORAGE_KEY);
const parsedConsent = savedConsent ? JSON.parse(savedConsent) : null;

export const cookieState = reactive({
  hasAnswered: !!parsedConsent,
  showSettings: false,
  preferences: parsedConsent || {
    maps: false,
    chatbot: false,
  }
});

export function saveCookiePreferences(prefs) {
  cookieState.preferences = { ...prefs };
  cookieState.hasAnswered = true;
  cookieState.showSettings = false;
  localStorage.setItem(STORAGE_KEY, JSON.stringify(cookieState.preferences));
}

export function acceptAll() {
  saveCookiePreferences({ maps: true, chatbot: true });
}

export function rejectAll() {
  saveCookiePreferences({ maps: false, chatbot: false });
}

export function openCookieSettings() {
  cookieState.showSettings = true;
}

export function closeCookieSettings() {
  cookieState.showSettings = false;
}