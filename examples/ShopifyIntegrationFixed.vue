<template>
  <div class="shopify-integration">
    <div class="integration-header">
      <h1 class="text-3xl font-bold">Joe shop</h1>
      <p class="text-gray-600 mt-2">The name of the plugin. Visible in the ticket sidebar.</p>
    </div>

    <form class="integration-form mt-8">
      <!-- App type -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          App type
        </label>
        <select class="w-full px-3 py-2 border border-gray-300 rounded-md bg-white">
          <option>Shopify</option>
        </select>
      </div>

      <!-- Webshop Domain - FIXED VERSION -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Webshop Domain
        </label>
        <p class="text-sm text-gray-500 mb-2">
          Your shop domain (without https://).
        </p>
        <input 
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
          name="webshop_domain"
          placeholder="trengo-demo.myshopify.com"
          type="url"
          v-model="webshopDomain"
        />
      </div>

      <!-- API Key -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          API Key
        </label>
        <p class="text-sm text-gray-500 mb-2">
          API key. <a href="#" class="text-blue-600 hover:underline">Learn how</a>
        </p>
        <input 
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
          name="api_key"
          placeholder="••••••••••••••••••••••••••••••••••••••••"
          type="password"
          v-model="apiKey"
        />
      </div>

      <!-- API Secret Key -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          API secret key
        </label>
        <p class="text-sm text-gray-500 mb-2">
          Your secret key. <a href="#" class="text-blue-600 hover:underline">Learn how</a>
        </p>
        <input 
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
          name="api_secret"
          placeholder="••••••••••••••••••••••••••••••••••••••••"
          type="password"
          v-model="apiSecret"
        />
      </div>

      <!-- Form Actions -->
      <div class="flex gap-4 mt-8">
        <button 
          type="submit"
          class="px-6 py-2 bg-black text-white rounded-md hover:bg-gray-800 focus:ring-2 focus:ring-gray-500"
        >
          Save changes
        </button>
        <button 
          type="button"
          class="px-6 py-2 text-red-600 border border-red-300 rounded-md hover:bg-red-50 focus:ring-2 focus:ring-red-500"
          @click="uninstallPlugin"
        >
          Uninstall plugin
        </button>
      </div>
    </form>

    <!-- BEFORE/AFTER Comparison -->
    <div class="comparison-section mt-12 p-6 bg-gray-100 rounded-lg">
      <h3 class="text-xl font-bold mb-4">🔧 Fix Applied</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- BEFORE: Problematic -->
        <div class="before-example p-4 bg-red-50 border border-red-200 rounded">
          <h4 class="font-semibold text-red-800 mb-2">❌ BEFORE (Problematic)</h4>
          <pre class="text-sm text-red-700 bg-red-100 p-2 rounded"><code>&lt;input 
  class="mb-6 w-full px-3 py-2 border..."
  name="webshop_domain"
  placeholder="trengo-demo.myshopify.com"
/&gt;</code></pre>
          <p class="text-sm text-red-600 mt-2">
            ⚠️ Input has mb-6 class causing top alignment
          </p>
        </div>

        <!-- AFTER: Fixed -->
        <div class="after-example p-4 bg-green-50 border border-green-200 rounded">
          <h4 class="font-semibold text-green-800 mb-2">✅ AFTER (Fixed)</h4>
          <pre class="text-sm text-green-700 bg-green-100 p-2 rounded"><code>&lt;div class="mb-6"&gt;
  &lt;label&gt;Webshop Domain&lt;/label&gt;
  &lt;input 
    class="w-full px-3 py-2 border..."
    name="webshop_domain"
    placeholder="trengo-demo.myshopify.com"
  /&gt;
&lt;/div&gt;</code></pre>
          <p class="text-sm text-green-600 mt-2">
            ✅ Container has mb-6, input is properly centered
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

// Form data
const webshopDomain = ref('trengo-demo.myshopify.com')
const apiKey = ref('')
const apiSecret = ref('')

// Methods
const uninstallPlugin = () => {
  if (confirm('Are you sure you want to uninstall this plugin?')) {
    // Handle uninstall logic
    console.log('Plugin uninstalled')
  }
}

const submitForm = () => {
  // Handle form submission
  console.log('Saving integration settings:', {
    webshopDomain: webshopDomain.value,
    apiKey: apiKey.value,
    apiSecret: apiSecret.value
  })
}
</script>

<style scoped>
.shopify-integration {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
}

.integration-header {
  border-bottom: 1px solid #e5e7eb;
  padding-bottom: 1rem;
}

.integration-form {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

/* Ensure inputs are properly centered and aligned */
.integration-form input,
.integration-form select {
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.integration-form input:focus,
.integration-form select:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* Code blocks in comparison */
pre {
  white-space: pre-wrap;
  word-wrap: break-word;
  font-family: 'Monaco', 'Courier New', monospace;
}
</style>