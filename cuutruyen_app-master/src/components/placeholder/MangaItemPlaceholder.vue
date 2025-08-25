<template>
  <div class="w-36 md:w-40 lg:w-48 flex flex-none flex-col justify-between rounded-lg snap-start"
  >
    <div
      class="w-full flex-grow relative rounded-lg overflow-hidden shadow-lg"
    >
      <canvas class="w-full h-full object-cover bg-gray-400" width="320" height="480"></canvas>
    </div>

    <div class="px-2 py-2 w-full">
      <h3 class="text-gray-800 font-bold mb-1 truncate">Loading...</h3>
      <h4 class="text-xs uppercase tracking-wide color text-gray-700 truncate">Loading...</h4>
    </div>
  </div>
</template>
