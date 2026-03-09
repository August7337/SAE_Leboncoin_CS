<script setup></script>

<template>
  <header
    id="main-header"
    class="w-full border-b border-gray-200 bg-white py-3 sticky top-0 z-40 left-0 transition-shadow duration-200"
  >
    <div
      class="mx-auto h-16 flex items-center justify-between gap-4 max-w-6xl px-6 md:px-12 xl:px-6"
    >
      <div class="flex items-center gap-4">
        <a href="/" class="flex-shrink-0">
          <img
            src="/assets/Leboncoin_logo.svg"
            alt="Logo leboncoin"
            class="h-8 w-auto object-contain"
          />
        </a>
      </div>

      <a
        href="#"
        id="header-create-annonce-btn"
        class="hidden md:flex items-center gap-2 bg-[#ea580c] hover:bg-[#c2410c] text-white transition-colors font-bold py-2.5 px-5 rounded-xl shadow-sm"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
          class="w-6 h-6 text-white"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M12 9v6m3-3H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
          />
        </svg>
        <span>Déposer une annonce</span>
      </a>

      <nav class="flex items-center gap-6 text-gray-700 shrink-0">
        <a
          href="#"
          id="header-help-link"
          class="relative hidden md:flex flex-col items-center gap-1 group w-16"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            class="w-6 h-6 group-hover:text-black transition-colors"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9 5.25h.008v.008H12v-.008z"
            />
          </svg>
          <span class="text-xs font-medium group-hover:text-black transition-colors">Aide</span>

          <span
            class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"
          ></span>
        </a>

        <a
          href="#"
          id="header-searches-link"
          class="relative hidden md:flex flex-col items-center gap-1 group"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            class="w-6 h-6 group-hover:text-black transition-colors"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0"
            />
          </svg>
          <span class="text-xs font-medium group-hover:text-black transition-colors"
            >Mes recherches</span
          >

          <span
            class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"
          ></span>
        </a>

        <a
          href="#"
          id="header-favorites-link"
          class="relative hidden md:flex flex-col items-center gap-1 group w-16"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            class="w-6 h-6 group-hover:text-black transition-colors"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"
            />
          </svg>
          <span class="text-xs font-medium group-hover:text-black transition-colors">Favoris</span>

          <span
            class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"
          ></span>
        </a>
        <nav>
          <a
            href="#"
            id="header-user-dashboard-link"
            class="relative hidden md:flex flex-col items-center gap-1 group"
          >
            <img class="rounded-full h-6 z-6" src="https://augustin-tarit.dev/tim.jpeg" alt="" />
            <span class="text-xs font-medium group-hover:text-black transition-colors">Tim</span>

            <span
              class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"
            ></span>
          </a>
        </nav>
        <nav>
          <a
            href="#"
            id="header-login-link"
            class="relative flex flex-col items-center gap-1 group"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-6 h-6 group-hover:text-black transition-colors"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"
              />
            </svg>
            <span class="text-xs font-medium group-hover:text-black transition-colors"
              >Se connecter</span
            >

            <span
              class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"
            ></span>
          </a>
        </nav>
      </nav>
    </div>
  </header>
</template>

<style scoped></style>
