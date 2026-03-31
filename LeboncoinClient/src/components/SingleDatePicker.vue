<script setup>
import { ref, watch, onMounted, onUnmounted, nextTick } from 'vue'
import flatpickr from 'flatpickr'
import { French } from 'flatpickr/dist/l10n/fr.js'
import 'flatpickr/dist/flatpickr.min.css'

const props = defineProps({
  modelValue: {
    type: String,
    default: '',
  },
  minDate: {
    type: String,
    default: null,
  },
  maxDate: {
    type: String,
    default: null,
  },
  // Date the calendar opens on when no value is selected
  defaultDate: {
    type: String,
    default: null,
  },
  placeholder: {
    type: String,
    default: 'Sélectionnez une date',
  },
  hasError: {
    type: Boolean,
    default: false,
  },
  // Orange banner text shown at the top of the calendar
  bannerText: {
    type: String,
    default: null,
  },
})

const emit = defineEmits(['update:modelValue'])

const inputEl = ref(null)
const isFocused = ref(false)
let picker = null
let internalValue = ''

function parseYMD(str) {
  if (!str) return null
  const [y, m, d] = str.split('-').map(Number)
  return new Date(y, m - 1, d)
}

function attachBanner(instance) {
  if (!props.bannerText || !instance?.calendarContainer) return
  const existing = instance.calendarContainer.querySelector('.fp-single-banner')
  if (existing) existing.remove()
  const header = document.createElement('div')
  header.className = 'fp-single-banner'
  header.style.cssText = `
    padding: 14px 16px;
    background: #EA580C;
    text-align: center;
    font-size: 13px;
    font-weight: 600;
    color: white;
    border-radius: 12px 12px 0 0;
    letter-spacing: 0.3px;
  `
  header.textContent = props.bannerText
  instance.calendarContainer.insertBefore(header, instance.calendarContainer.firstChild)
}

function destroyPicker() {
  if (picker) {
    try { picker.destroy() } catch (e) {}
    picker = null
  }
}

function initPicker() {
  if (!inputEl.value) return
  destroyPicker()

  const config = {
    // Display in French format inside the input; emit YYYY-MM-DD via onChange
    dateFormat: 'd/m/Y',
    locale: French,
    mode: 'single',
    // Arrows only — month/year label is not clickable
    monthSelectorType: 'static',
    onChange(selectedDates) {
      if (selectedDates.length === 1) {
        const val = selectedDates[0].toISOString().split('T')[0]
        internalValue = val
        emit('update:modelValue', val)
      } else {
        internalValue = ''
        emit('update:modelValue', '')
      }
    },
    onOpen(selectedDates, dateStr, instance) {
      isFocused.value = true
      attachBanner(instance)
    },
    onClose() {
      isFocused.value = false
    },
  }

  if (props.minDate) config.minDate = props.minDate
  if (props.maxDate) config.maxDate = props.maxDate

  // Open at defaultDate when no value is selected yet
  if (props.defaultDate && !props.modelValue) {
    config.defaultDate = parseYMD(props.defaultDate)
  }

  try {
    picker = flatpickr(inputEl.value, config)
    if (props.modelValue) {
      const d = parseYMD(props.modelValue)
      if (d) {
        picker.setDate(d, false)
        internalValue = props.modelValue
      }
    }
  } catch (e) {
    console.warn('SingleDatePicker: erreur d\'initialisation', e)
  }
}

onMounted(() => nextTick(() => initPicker()))
onUnmounted(() => destroyPicker())

watch(
  () => props.modelValue,
  (newVal) => {
    if (!picker || newVal === internalValue) return
    if (newVal) {
      const d = parseYMD(newVal)
      if (d) {
        picker.setDate(d, false)
        internalValue = newVal
      }
    } else {
      picker.clear()
      internalValue = ''
    }
  },
)
</script>

<template>
  <input
    ref="inputEl"
    type="text"
    :placeholder="placeholder"
    readonly
    :class="[
      'sdp-input',
      hasError ? 'sdp-error' : '',
      isFocused ? 'sdp-focused' : '',
    ]"
  />
</template>

<style scoped>
.sdp-input {
  width: 100%;
  border: 1px solid #d1d5db;
  border-radius: 12px;
  padding: 10px 14px;
  font-size: 14px;
  outline: none;
  cursor: pointer;
  background: white;
  transition: border-color 0.15s ease, box-shadow 0.15s ease;
  color: #111827;
  /* Prevent the browser from showing the text-input caret */
  caret-color: transparent;
}

.sdp-input::placeholder {
  color: #9ca3af;
}

.sdp-input:hover {
  border-color: #9ca3af;
}

.sdp-input.sdp-focused,
.sdp-input:focus {
  border-color: #ea580c;
  box-shadow: 0 0 0 4px rgba(234, 88, 12, 0.12);
}

.sdp-input.sdp-error {
  border-color: #f87171;
}

.sdp-input.sdp-error.sdp-focused,
.sdp-input.sdp-error:focus {
  border-color: #ef4444;
  box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.12);
}
</style>
