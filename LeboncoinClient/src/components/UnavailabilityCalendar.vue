<script setup>
import { ref, computed } from 'vue'
import api from '@/api/axios'

const props = defineProps({
  annonceId: {
    type: [String, Number],
    required: true,
  },
  modelValue: {
    type: Array,
    default: () => [],
  },
})

const emit = defineEmits(['update:modelValue'])

const isAddingUnavail = ref(false)
const selectionStart = ref(null)
const hoveredDate = ref(null)

const currentYear = ref(new Date().getFullYear())
const currentMonth = ref(new Date().getMonth())

const monthNames = [
  'Janvier','Février','Mars','Avril','Mai','Juin',
  'Juillet','Août','Septembre','Octobre','Novembre','Décembre',
]
const currentMonthName = computed(() => monthNames[currentMonth.value])

const today = new Date()

const todayStr = computed(() => {
  const y = today.getFullYear()
  const m = String(today.getMonth() + 1).padStart(2, '0')
  const d = String(today.getDate()).padStart(2, '0')
  return `${y}-${m}-${d}`
})

const blockPastNav = computed(() => {
  if (currentYear.value < today.getFullYear()) return true
  if (currentYear.value === today.getFullYear() && currentMonth.value <= today.getMonth()) return true
  return false
})

const blankDays = computed(() => {
  let firstDay = new Date(currentYear.value, currentMonth.value, 1).getDay()
  return firstDay === 0 ? 6 : firstDay - 1
})

const daysInMonth = computed(() => {
  const days = new Date(currentYear.value, currentMonth.value + 1, 0).getDate()
  const arr = []
  for (let i = 1; i <= days; i++) {
    const y = currentYear.value
    const m = String(currentMonth.value + 1).padStart(2, '0')
    const d = String(i).padStart(2, '0')
    arr.push({ dateNum: i, dateStr: `${y}-${m}-${d}` })
  }
  return arr
})

function isPastDate(dateStr) {
  return dateStr < todayStr.value
}

function isUnavailable(dateStr) {
  return props.modelValue.includes(dateStr)
}

function isSelectedOrHovered(dateStr) {
  if (!selectionStart.value) return false
  if (selectionStart.value === dateStr) return true
  if (hoveredDate.value) {
    const d = new Date(dateStr)
    const s = new Date(selectionStart.value)
    const h = new Date(hoveredDate.value)
    const min = new Date(Math.min(s, h))
    const max = new Date(Math.max(s, h))
    return d >= min && d <= max
  }
  return false
}

function changeMonth(delta) {
  if (delta === -1 && blockPastNav.value) return
  let newMonth = currentMonth.value + delta
  if (newMonth > 11) {
    newMonth = 0
    currentYear.value++
  } else if (newMonth < 0) {
    newMonth = 11
    currentYear.value--
  }
  currentMonth.value = newMonth
}

async function handleDayClick(dateStr) {
  if (isAddingUnavail.value) return

  if (!selectionStart.value) {
    selectionStart.value = dateStr
  } else {
    const start = selectionStart.value
    const end = dateStr
    selectionStart.value = null
    hoveredDate.value = null

    isAddingUnavail.value = true
    try {
      const isUnblocking = isUnavailable(start)
      const sDate = new Date(start)
      const eDate = new Date(end)
      const minStr = sDate <= eDate ? start : end
      const maxStr = sDate <= eDate ? end : start

      // Build the full range of dates locally
      const rangeDates = []
      let curr = new Date(minStr)
      const endD = new Date(maxStr)
      while (curr <= endD) {
        rangeDates.push(curr.toISOString().split('T')[0])
        curr.setDate(curr.getDate() + 1)
      }

      if (isUnblocking) {
        // Optimistic: remove immediately from UI
        const updated = props.modelValue.filter(d => !rangeDates.includes(d))
        emit('update:modelValue', updated)
        // Then delete from server in background
        for (const dStr of rangeDates) {
          try { await api.delete(`/Annonces/${props.annonceId}/indisponibilites/${dStr}`) } catch (e) {}
        }
      } else {
        // Optimistic: add immediately to UI (deduplicate)
        const updated = [...new Set([...props.modelValue, ...rangeDates])].sort()
        emit('update:modelValue', updated)
        // Then persist to server
        await api.post(`/Annonces/${props.annonceId}/indisponibilites`, {
          startDate: minStr,
          endDate: maxStr,
        })
      }
    } catch (e) {
      console.error(e)
      alert('Erreur lors de la modification des disponibilités.')
    } finally {
      isAddingUnavail.value = false
    }
  }
}
</script>

<template>
  <div class="unavail-calendar w-full max-w-[320px]">
    <!-- Header mois -->
    <div class="cal-months">
      <span
        class="cal-prev"
        @click="changeMonth(-1)"
        :class="{ 'cal-nav-disabled': blockPastNav }"
      >
        <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14">
          <path d="M9.5 12L4.5 7l5-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </span>
      <div class="cal-month-label">{{ currentMonthName }} {{ currentYear }}</div>
      <span class="cal-next" @click="changeMonth(1)">
        <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14">
          <path d="M4.5 12l5-5-5-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </span>
    </div>

    <!-- Jours de la semaine -->
    <div class="cal-weekdays">
      <span v-for="day in ['lun','mar','mer','jeu','ven','sam','dim']" :key="day" class="cal-weekday">{{ day }}</span>
    </div>

    <!-- Grille des jours -->
    <div class="grid grid-cols-7 place-items-center">
      <span
        v-for="blank in blankDays"
        :key="'blank-' + blank"
        class="cal-day cal-day-filler"
      ></span>
      <span
        v-for="d in daysInMonth"
        :key="d.dateStr"
        @click="!isPastDate(d.dateStr) && handleDayClick(d.dateStr)"
        @mouseenter="!isPastDate(d.dateStr) && (hoveredDate = d.dateStr)"
        @mouseleave="hoveredDate = null"
        class="cal-day relative"
        :class="{
          'cal-day-past': isPastDate(d.dateStr),
          'cal-day-unavail': isUnavailable(d.dateStr) && !isPastDate(d.dateStr),
          'cal-day-selected': isSelectedOrHovered(d.dateStr) && !isPastDate(d.dateStr),
          'cal-day-unavail-unsel': isUnavailable(d.dateStr) && !isSelectedOrHovered(d.dateStr) && !isPastDate(d.dateStr),
          'cal-day-start': selectionStart === d.dateStr && !isPastDate(d.dateStr),
        }"
      >
        {{ d.dateNum }}
        <span
          v-if="isAddingUnavail && (isSelectedOrHovered(d.dateStr) || selectionStart === d.dateStr) && !isPastDate(d.dateStr)"
          class="absolute inset-0 bg-white/30 rounded"
        ></span>
      </span>
    </div>
  </div>
</template>

<style scoped>
.unavail-calendar {
  background: white;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0,0,0,.1), 0 2px 4px -1px rgba(0,0,0,.06);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
  padding: 10px;
}

.cal-months {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.cal-month-label {
  font-weight: 600;
  font-size: 16px;
  color: #222;
  text-align: center;
}

.cal-prev,
.cal-next {
  color: #EA580C;
  cursor: pointer;
  transition: all 0.2s ease;
  height: 32px;
  width: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cal-prev:hover,
.cal-next:hover {
  opacity: 0.7;
  background: #fff7ed;
  border-radius: 50%;
}

.cal-nav-disabled {
  opacity: 0.3;
  cursor: not-allowed;
}
.cal-nav-disabled:hover {
  background: transparent !important;
  opacity: 0.3 !important;
}

.cal-weekdays {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  padding: 8px 0;
  font-weight: 500;
  font-size: 12px;
  color: #999;
  text-transform: lowercase;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 8px;
}

.cal-weekday {
  display: flex;
  align-items: center;
  justify-content: center;
}

.cal-day {
  width: 36px;
  height: 36px;
  font-size: 14px;
  color: #222;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s ease;
  cursor: pointer;
  margin: 2px 0;
  font-weight: 500;
}

.cal-day-filler {
  cursor: default;
}

.cal-day:hover:not(.cal-day-unavail):not(.cal-day-filler):not(.cal-day-past) {
  background-color: #f3f4f6;
}

.cal-day-past {
  opacity: 0.3;
  cursor: not-allowed;
}
.cal-day-past:hover {
  background: transparent !important;
}

.cal-day-selected,
.cal-day-start {
  background-color: #222 !important;
  color: white !important;
  font-weight: 600;
}

.cal-day-unavail {
  color: #9ca3af !important;
  text-decoration: line-through;
  text-decoration-color: #ef4444;
  text-decoration-thickness: 2px;
}
.cal-day-unavail:hover {
  background-color: #fee2e2 !important;
}

.cal-day-unavail-unsel {
  background-color: #e5e7eb !important;
  color: #9ca3af !important;
}
</style>
