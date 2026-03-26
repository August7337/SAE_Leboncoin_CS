<template>
  <div class="w-full">
    <div
      @dragover.prevent="isDragging = true"
      @dragleave.prevent="isDragging = false"
      @drop.prevent="handleDrop"
      :class="[
        'flex flex-col items-center justify-center border-2 border-dashed rounded-xl p-8 transition-all duration-200 cursor-pointer',
        isDragging ? 'border-[#ea580c] bg-orange-50' : 'border-gray-300 hover:border-orange-400 bg-white'
      ]"
      @click="$refs.fileInput.click()"
    >
      <input type="file" multiple :accept="accept" class="hidden" ref="fileInput" @change="handleFileSelect" />
      <svg class="w-10 h-10 text-gray-400 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
      </svg>
      <p class="text-sm font-bold text-gray-700">Cliquez ou glissez vos photos ici</p>
      <p class="text-xs text-gray-500 mt-2">Max {{ maxSizeMB }} MB par fichier</p>
    </div>

    <div v-if="files.length > 0" class="mt-4 grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-3">
      <div v-for="(file, index) in files" :key="index" class="relative group aspect-square">
        <img :src="file.preview" class="w-full h-full object-cover rounded-xl border border-gray-200" />
        <button type="button" @click.prevent="removeFile(index)" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1.5 shadow-md hover:bg-red-600 transition-colors">
          <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  accept: { type: String, default: 'image/jpeg, image/png, image/webp' },
  maxSizeMB: { type: Number, default: 10 }
})

const emit = defineEmits(['update:modelValue'])

const isDragging = ref(false)
const fileInput = ref(null)
const files = ref([])

watch(() => props.modelValue, (newVal) => {
  if (newVal.length === 0 && files.value.length > 0) {
    files.value.forEach(f => URL.revokeObjectURL(f.preview))
    files.value = []
  }
})

const processFiles = (fileList) => {
  const newFiles = Array.from(fileList).filter(file => {
    const isValidType = file.type.startsWith('image/')
    const isValidSize = file.size <= props.maxSizeMB * 1024 * 1024
    return isValidType && isValidSize
  }).map(file => ({
    file,
    preview: URL.createObjectURL(file)
  }))

  files.value = [...files.value, ...newFiles]
  emit('update:modelValue', files.value.map(f => f.file))
}

const handleDrop = (event) => {
  isDragging.value = false
  if (event.dataTransfer.files) processFiles(event.dataTransfer.files)
}

const handleFileSelect = (event) => {
  if (event.target.files) processFiles(event.target.files)
  event.target.value = '' 
}

const removeFile = (index) => {
  URL.revokeObjectURL(files.value[index].preview)
  files.value.splice(index, 1)
  emit('update:modelValue', files.value.map(f => f.file))
}
</script>