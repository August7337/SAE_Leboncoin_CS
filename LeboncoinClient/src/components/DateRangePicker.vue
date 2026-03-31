<script setup>
import { ref, watch, onMounted, onUnmounted, nextTick } from 'vue'
import flatpickr from 'flatpickr'
import { French } from 'flatpickr/dist/l10n/fr.js'
import rangePlugin from 'flatpickr/dist/plugins/rangePlugin.js'
import 'flatpickr/dist/flatpickr.min.css'

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({ start: '', end: '' }),
  },
  disabledDates: {
    type: Array,
    default: () => [],
  },
  minNights: {
    type: Number,
    default: 1,
  },
  showMonths: {
    type: Number,
    default: 2,
  },
  minDate: {
    type: String,
    default: 'today',
  },
  showMinimumBanner: {
    type: Boolean,
    default: false,
  },
  startLabel: {
    type: String,
    default: 'Arrivée',
  },
  endLabel: {
    type: String,
    default: 'Départ',
  },
})

const emit = defineEmits(['update:modelValue', 'warning'])

const startInput = ref(null)
const endInput = ref(null)
let picker = null

// Track the last value we emitted to detect external vs internal changes
const internalDates = ref({ start: '', end: '' })

function parseYMD(str) {
  if (!str) return null
  const [y, m, d] = str.split('-').map(Number)
  return new Date(y, m - 1, d)
}

function isDateDisabled(date) {
  const dateStr = date.toISOString().split('T')[0]
  return props.disabledDates.includes(dateStr)
}

function hasDisabledDatesInRange(startDate, endDate) {
  const current = new Date(startDate)
  while (current < endDate) {
    if (isDateDisabled(current)) return true
    current.setDate(current.getDate() + 1)
  }
  return false
}

function attachMinimumBanner(instance) {
  if (!props.showMinimumBanner || props.minNights <= 1) return
  const existing = instance.calendarContainer?.querySelector('.fp-minimum-header')
  if (existing) existing.remove()
  if (instance?.calendarContainer) {
    const header = document.createElement('div')
    header.className = 'fp-minimum-header'
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
    header.innerHTML = `Minimum requis&nbsp;: <strong>${props.minNights} nuit${props.minNights > 1 ? 's' : ''}</strong>`
    instance.calendarContainer.insertBefore(header, instance.calendarContainer.firstChild)
  }
}

function destroyPicker() {
  if (picker) {
    try { picker.destroy() } catch (e) {}
    picker = null
  }
}

function initPicker() {
  if (!startInput.value || !endInput.value) return
  destroyPicker()

  const config = {
    dateFormat: 'd/m/Y',
    locale: French,
    showMonths: props.showMonths,
    mode: 'range',
    monthSelectorType: 'dropdown',
    closeOnSelect: false,
    plugins: [rangePlugin({ input: endInput.value })],
    disable: [(date) => isDateDisabled(date)],
    onChange(selectedDates) {
      if (selectedDates.length === 1) {
        const start = selectedDates[0].toISOString().split('T')[0]
        internalDates.value = { start, end: '' }
        emit('update:modelValue', { start, end: '' })
        emit('warning', '')
        return
      }
      if (selectedDates.length === 2) {
        const [start, end] = selectedDates
        const nights = Math.max(0, Math.round((end - start) / (1000 * 60 * 60 * 24)))

        if (hasDisabledDatesInRange(start, end)) {
          picker.clear()
          internalDates.value = { start: '', end: '' }
          emit('update:modelValue', { start: '', end: '' })
          emit('warning', '⚠️ Cette plage contient des dates réservées. Veuillez en choisir une autre.')
          return
        }

        if (props.minNights > 1 && nights < props.minNights) {
          picker.clear()
          internalDates.value = { start: '', end: '' }
          emit('update:modelValue', { start: '', end: '' })
          emit('warning', `⚠️ Minimum de ${props.minNights} nuit${props.minNights > 1 ? 's' : ''} requises. Vous avez sélectionné ${nights} nuit${nights > 1 ? 's' : ''}.`)
          return
        }

        const startStr = start.toISOString().split('T')[0]
        const endStr = end.toISOString().split('T')[0]
        internalDates.value = { start: startStr, end: endStr }
        emit('update:modelValue', { start: startStr, end: endStr })
        emit('warning', '')
      }
    },
    onOpen(selectedDates, dateStr, instance) {
      attachMinimumBanner(instance)
    },
  }

  if (props.minDate) {
    config.minDate = props.minDate
  }

  try {
    picker = flatpickr(startInput.value, config)

    // Set initial value if provided
    if (props.modelValue?.start && props.modelValue?.end) {
      const s = parseYMD(props.modelValue.start)
      const e = parseYMD(props.modelValue.end)
      if (s && e) {
        picker.setDate([s, e], false)
        internalDates.value = { start: props.modelValue.start, end: props.modelValue.end }
      }
    }
  } catch (e) {
    console.warn('DateRangePicker: erreur d\'initialisation', e)
  }
}

onMounted(() => {
  nextTick(() => initPicker())
})

onUnmounted(() => {
  destroyPicker()
})

// Re-init when disabledDates or minNights changes (e.g. annonce loaded)
watch(
  () => [props.disabledDates, props.minNights, props.showMonths],
  async () => {
    await nextTick()
    initPicker()
  },
  { deep: true },
)

// Sync external modelValue changes into flatpickr (e.g. async data load)
watch(
  () => props.modelValue,
  (newVal) => {
    if (!picker) return
    const sameAsInternal =
      newVal?.start === internalDates.value.start &&
      newVal?.end === internalDates.value.end
    if (sameAsInternal) return

    if (newVal?.start && newVal?.end) {
      const s = parseYMD(newVal.start)
      const e = parseYMD(newVal.end)
      if (s && e) {
        picker.setDate([s, e], false)
        internalDates.value = { start: newVal.start, end: newVal.end }
      }
    } else if (!newVal?.start && !newVal?.end) {
      picker.clear()
      internalDates.value = { start: '', end: '' }
    }
  },
  { deep: true },
)
</script>

<template>
  <div class="grid grid-cols-2 gap-3">
    <div>
      <label
        v-if="startLabel"
        class="block text-xs font-bold text-slate-500 mb-1 ml-1"
      >{{ startLabel }}</label>
      <input
        ref="startInput"
        type="text"
        :placeholder="startLabel || 'Sélectionnez'"
        readonly
        class="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-orange-500 outline-none cursor-pointer bg-white"
      />
    </div>
    <div>
      <label
        v-if="endLabel"
        class="block text-xs font-bold text-slate-500 mb-1 ml-1"
      >{{ endLabel }}</label>
      <input
        ref="endInput"
        type="text"
        :placeholder="endLabel || 'Sélectionnez'"
        readonly
        class="w-full border border-gray-300 rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-orange-500 outline-none cursor-pointer bg-white"
      />
    </div>
  </div>
</template>
