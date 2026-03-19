
<template>
  <div v-if="loginSuccess" class="fixed inset-0 flex items-center justify-center bg-white/95 z-50">
      <div class="text-center">
        <div class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-[#ea580c]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <p class="text-lg font-bold text-gray-800">{{ successMessage }}</p>
    </div>
  </div>
    <div class="edit-pfp-container">
      <h1 style="font-weight: bold;">Modifier ma photo de profil</h1>
  
      <div class="cropper-wrapper">
        <cropper
  ref="cropperRef"
  class="cropper"
  :src="imageSource"
  :stencil-props="{
    aspectRatio: 1/1,
    movable: true,   
    resizable: true 
  }"
  :stencil-component="CircleStencil" 
/>
      </div>
  
      <div class="controls">
        <label class="upload-btn">
          Choisir une image
          <input type="file" @change="onFileChange" accept="image/*" hidden />
        </label>
  
        <button 
          @click="saveImage" 
          :disabled="!imageSource || isUploading"
          class="save-btn"
        >
          {{ isUploading ? 'Enregistrement...' : 'Valider la photo' }}
        </button>
      </div>
    </div>
  </template>
  
  <script setup>
  import { useRouter } from 'vue-router'; 


  import 'vue-advanced-cropper/dist/style.css';
  import { ref } from 'vue';
  import { Cropper, CircleStencil } from 'vue-advanced-cropper';
  
  import axios from 'axios';
  import { authState } from '@/auth';
  const loginSuccess = ref(false)
  const successMessage = ref("photo de profil changée avec succès")
  const cropperRef = ref(null);
  const imageSource = ref(authState.user?.photoUrl || null);
  const isUploading = ref(false);
  const router = useRouter();
  
  const onFileChange = (event) => {
  const file = event.target.files[0];
  if (file) {
   
    if (imageSource.value && imageSource.value.startsWith('blob:')) {
      URL.revokeObjectURL(imageSource.value);
    }
    imageSource.value = URL.createObjectURL(file);
  }
};
  
  const saveImage = async () => {
    const { canvas } = cropperRef.value.getResult();
    if (!canvas) return;
  
    isUploading.value = true;
  
    
    canvas.toBlob(async (blob) => {
      const formData = new FormData();
      formData.append('file', blob, 'pfp.jpg');
  
      try {
        const response = await axios.post(`https://localhost:7057/api/Utilisateurs/${authState.user.idutilisateur}/upload-pfp`, formData);
  
 
  const timestampedUrl = `${response.data.newUrl}?t=${new Date().getTime()}`;


  authState.setUser({ 
    ...authState.user, 
    profilePhotoPath: timestampedUrl 
  });
  loginSuccess.value = true;
setTimeout(() => {
  router.push({ name: 'profile' });
}, 800);
  //alert("Photo mise à jour !");
      } catch (error) {
        console.error("Upload failed", error);
      } finally {
        isUploading.value = false;
      }
    }, 'image/jpeg');
  };
  </script>
  
  <style scoped>
  .edit-pfp-container {
    max-width: 500px;
    margin: 50px auto;
    text-align: center;
    padding: 20px;
  }
  
:deep(.vue-circle-stencil) {
  border: 2px solid #ea580c; 
}
  
  .cropper-wrapper {
    width: 100%;
    height: 400px;
    background: #ddd;
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 20px;
  }
  
  .cropper {
    width: 100%;
    height: 100%;
  }
  
  .controls {
    display: flex;
    gap: 15px;
    justify-content: center;
  }
  
  .upload-btn, .save-btn {
    padding: 12px 24px;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
    transition: 0.2s;
  }
  
  .upload-btn {
    background: #f3f4f6;
    color: #374151;
  }
  
  .save-btn {
    background: #ea580c;
    color: white;
    border: none;
  }
  
  .save-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  </style>