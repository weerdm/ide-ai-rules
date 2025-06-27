<template>
  <div class="integration-hub">
    <!-- Integration Header -->
    <div class="integration-header">
      <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ integrationTitle }}</h1>
      <p class="text-sm text-gray-600">
        The name of the plugin. Visible in the ticket sidebar.
      </p>
    </div>

    <!-- Integration Form -->
    <form @submit.prevent="handleSaveSettings" class="integration-form mt-8">
      
      <!-- App Type Selection - FIXED VERSION (mb-6 on container) -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          App type
        </label>
        <select 
          v-model="formData.appType"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
          name="app_type"
          required
        >
          <option value="">Select app type</option>
          <option value="shopify">Shopify</option>
          <option value="woocommerce">WooCommerce</option>
          <option value="magento">Magento</option>
        </select>
      </div>

      <!-- Webshop Domain Field - FIXED VERSION (mb-6 on container, NOT on input) -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Webshop Domain
        </label>
        <p class="text-sm text-gray-500 mb-2">
          Your shop domain (without https://).
        </p>
        <input 
          v-model="formData.webshopDomain"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
          name="webshop_domain"
          placeholder="trengo-demo.myshopify.com"
          type="url"
          required
        />
      </div>

      <!-- API Key Field - FIXED VERSION -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          API Key
        </label>
        <p class="text-sm text-gray-500 mb-2">
          API key. <a href="#" class="text-blue-600 hover:underline">Learn how</a>
        </p>
        <input 
          v-model="formData.apiKey"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
          name="api_key"
          placeholder="••••••••••••••••••••••••••••••••••••••••"
          type="password"
          required
        />
      </div>

      <!-- API Secret Key Field - FIXED VERSION -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          API secret key
        </label>
        <p class="text-sm text-gray-500 mb-2">
          Your secret key. <a href="#" class="text-blue-600 hover:underline">Learn how</a>
        </p>
        <input 
          v-model="formData.apiSecret"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
          name="api_secret"
          placeholder="••••••••••••••••••••••••••••••••••••••••"
          type="password"
          required
        />
      </div>

      <!-- Optional Settings -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Webhook URL (Optional)
        </label>
        <input 
          v-model="formData.webhookUrl"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
          name="webhook_url"
          placeholder="https://your-webhook.com/endpoint"
          type="url"
        />
      </div>

      <!-- Form Actions -->
      <div class="flex items-center justify-between pt-6 border-t border-gray-200">
        <button 
          type="submit"
          :disabled="isLoading"
          class="px-6 py-2 bg-black text-white rounded-md hover:bg-gray-800 focus:ring-2 focus:ring-gray-500 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span v-if="isLoading" class="inline-flex items-center">
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Saving...
          </span>
          <span v-else>Save changes</span>
        </button>
        
        <button 
          type="button"
          @click="handleUninstall"
          class="px-6 py-2 text-red-600 border border-red-300 rounded-md hover:bg-red-50 focus:ring-2 focus:ring-red-500"
        >
          Uninstall plugin
        </button>
      </div>
    </form>

    <!-- Success/Error Messages -->
    <div v-if="notification.show" class="mt-6 p-4 rounded-md" :class="notificationClass">
      <div class="flex items-center">
        <svg v-if="notification.type === 'success'" class="h-5 w-5 text-green-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
        </svg>
        <svg v-else class="h-5 w-5 text-red-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
        </svg>
        <span>{{ notification.message }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'

// Props
interface Props {
  integrationId?: string
  initialData?: Partial<IntegrationData>
}

const props = withDefaults(defineProps<Props>(), {
  integrationId: '',
  initialData: () => ({})
})

// Emits
interface Emits {
  saved: [data: IntegrationData]
  uninstalled: []
  error: [error: string]
}

const emit = defineEmits<Emits>()

// Types
interface IntegrationData {
  appType: string
  webshopDomain: string
  apiKey: string
  apiSecret: string
  webhookUrl?: string
}

interface Notification {
  show: boolean
  type: 'success' | 'error'
  message: string
}

// Reactive state
const integrationTitle = ref('Joe shop')
const isLoading = ref(false)

const formData = reactive<IntegrationData>({
  appType: '',
  webshopDomain: '',
  apiKey: '',
  apiSecret: '',
  webhookUrl: '',
  ...props.initialData
})

const notification = reactive<Notification>({
  show: false,
  type: 'success',
  message: ''
})

// Computed
const notificationClass = computed(() => ({
  'bg-green-50 text-green-800 border border-green-200': notification.type === 'success',
  'bg-red-50 text-red-800 border border-red-200': notification.type === 'error'
}))

// Methods
const showNotification = (type: 'success' | 'error', message: string) => {
  notification.type = type
  notification.message = message
  notification.show = true
  
  // Auto-hide after 5 seconds
  setTimeout(() => {
    notification.show = false
  }, 5000)
}

const validateForm = (): string[] => {
  const errors: string[] = []
  
  if (!formData.appType) errors.push('App type is required')
  if (!formData.webshopDomain) errors.push('Webshop domain is required')
  if (!formData.apiKey) errors.push('API key is required')
  if (!formData.apiSecret) errors.push('API secret key is required')
  
  // Validate domain format
  if (formData.webshopDomain && !isValidDomain(formData.webshopDomain)) {
    errors.push('Please enter a valid domain')
  }
  
  return errors
}

const isValidDomain = (domain: string): boolean => {
  const domainRegex = /^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$/
  return domainRegex.test(domain)
}

const handleSaveSettings = async () => {
  isLoading.value = true
  
  try {
    // Validate form
    const errors = validateForm()
    if (errors.length > 0) {
      throw new Error(errors.join(', '))
    }

    // Simulate API call (replace with actual API call)
    await saveIntegrationSettings(formData)
    
    // Success
    showNotification('success', 'Integration settings saved successfully!')
    emit('saved', { ...formData })
    
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Failed to save settings'
    showNotification('error', errorMessage)
    emit('error', errorMessage)
  } finally {
    isLoading.value = false
  }
}

const handleUninstall = () => {
  if (confirm('Are you sure you want to uninstall this plugin? This action cannot be undone.')) {
    showNotification('success', 'Plugin uninstalled successfully')
    emit('uninstalled')
  }
}

// API calls (replace with actual implementation)
const saveIntegrationSettings = async (data: IntegrationData): Promise<void> => {
  // Replace this with your actual API call
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      // Simulate success/failure
      if (Math.random() > 0.1) {
        resolve()
      } else {
        reject(new Error('Network error'))
      }
    }, 1000)
  })
}

// Lifecycle
onMounted(() => {
  // Load initial data if needed
  console.log('Integration hub mounted', props.integrationId)
})

// Expose methods for parent components
defineExpose({
  saveSettings: handleSaveSettings,
  resetForm: () => {
    Object.assign(formData, {
      appType: '',
      webshopDomain: '',
      apiKey: '',
      apiSecret: '',
      webhookUrl: ''
    })
  }
})
</script>

<style scoped>
.integration-hub {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.integration-header {
  border-bottom: 1px solid #e5e7eb;
  padding-bottom: 1.5rem;
  margin-bottom: 2rem;
}

.integration-form {
  /* Ensure proper form spacing */
}

/* CRITICAL: Override any global styles that might add mb-6 to inputs */
.integration-form input,
.integration-form select {
  margin-bottom: 0 !important;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.integration-form input:focus,
.integration-form select:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* Ensure proper spacing is maintained by containers */
.mb-6 {
  margin-bottom: 1.5rem;
}

.mb-6:last-child {
  margin-bottom: 0;
}

/* Button hover states */
button:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

button:active:not(:disabled) {
  transform: translateY(0);
}

/* Loading state */
.animate-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Responsive design */
@media (max-width: 640px) {
  .integration-hub {
    padding: 1rem;
    margin: 0.5rem;
  }
  
  .flex.items-center.justify-between {
    flex-direction: column;
    gap: 1rem;
  }
  
  .flex.items-center.justify-between button {
    width: 100%;
  }
}
</style>