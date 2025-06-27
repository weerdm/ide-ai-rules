<template>
  <!-- PROBLEMATIC EXAMPLE: This shows the current issue -->
  <div class="integration-hub">
    <h2 class="text-2xl font-bold mb-4">Integration Settings - BEFORE (Problematic)</h2>
    
    <!-- FIXED: Container has mb-6, input does not -->
    <div class="form-section mb-6">
      <label class="block text-sm font-medium text-gray-700 mb-2">
        Webshop Domain (FIXED - mb-6 on container)
      </label>
      <input 
        class="w-full h-full grow input#url.h-full.grow.w-full px-3 py-2 border border-gray-300 rounded-md"
        name="webshop_domain"
        placeholder="Your shop domain (without https://)."
        type="text"
      />
    </div>

    <!-- Another fixed input -->
    <div class="form-section mb-6">
      <label class="block text-sm font-medium text-gray-700 mb-2">
        API Key (FIXED - mb-6 on container)
      </label>
      <input 
        class="w-full px-3 py-2 border border-gray-300 rounded-md"
        name="api_key"
        placeholder="Enter your API key"
        type="password"
      />
    </div>

    <hr class="my-8 border-red-300" />

    <!-- FIXED EXAMPLE: This shows the correct pattern -->
    <h2 class="text-2xl font-bold mb-4">Integration Settings - AFTER (Fixed)</h2>
    
    <!-- Container has mb-6, input does not -->
    <div class="mb-6">
      <label class="block text-sm font-medium text-gray-700 mb-2">
        Webshop Domain (FIXED - mb-6 on container)
      </label>
      <input 
        class="w-full h-full grow input#url.h-full.grow.w-full px-3 py-2 border border-gray-300 rounded-md"
        name="webshop_domain_fixed"
        placeholder="Your shop domain (without https://)."
        type="text"
      />
    </div>

    <!-- Another fixed input -->
    <div class="mb-6">
      <label class="block text-sm font-medium text-gray-700 mb-2">
        API Key (FIXED - mb-6 on container)
      </label>
      <input 
        class="w-full px-3 py-2 border border-gray-300 rounded-md"
        name="api_key_fixed"
        placeholder="Enter your API key"
        type="password"
      />
    </div>

    <!-- Submit button -->
    <div class="mt-6">
      <button class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
        Save Integration Settings
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
// This component demonstrates the integration hub CSS issue and fix
// The problematic inputs have mb-6 directly on the input element
// The fixed inputs have mb-6 on the container div instead
</script>

<style scoped>
.integration-hub {
  max-width: 600px;
  margin: 0 auto;
  padding: 2rem;
}

.form-section {
  border: 2px dashed #ef4444;
  padding: 1rem;
  margin-bottom: 1rem;
  background-color: #fef2f2;
}

/* Demonstrate the alignment issue more clearly */
.form-section input {
  /* This shows how mb-6 on inputs causes alignment issues */
  background-color: #fef3c7;
  border: 2px solid #f59e0b;
}

/* Show fixed pattern with better styling */
.mb-6 {
  border: 2px dashed #10b981;
  padding: 1rem;
  background-color: #ecfdf5;
}

.mb-6 input {
  background-color: #d1fae5;
  border: 2px solid #10b981;
}
</style>