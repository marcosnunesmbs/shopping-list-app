<template>
  <div
    class="item-card bg-white rounded-lg shadow-sm border border-gray-100 p-4 mb-3 flex items-center justify-between"
  >
    <div class="item-info">
      <div class="item-name font-medium text-neutral">{{ item.name }}</div>
      <div class="item-details text-sm text-neutral">
        {{ item.quantity }} x R$ {{ formatCurrency(item.unitPrice) }}
      </div>
    </div>
    <div class="flex items-center">
      <div class="item-total font-bold text-lg mr-4">
        {{ formatCurrency(item.total) }}
      </div>
      <div class="item-actions flex space-x-1">
        <button
          @click="editItem"
          class="text-info hover:text-gray-600 transition-colors p-1"
          title="Editar"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
            />
          </svg>
        </button>
        <button
          @click="deleteItem"
          class="text-error hover:text-gray-600 transition-colors p-1"
          title="Excluir"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
            />
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps, defineEmits } from "vue";

const props = defineProps({
  item: {
    type: Object,
    required: true,
  },
});

const emit = defineEmits(["edit", "delete"]);

function formatCurrency(value) {
  return value.toFixed(2).replace(".", ",");
}

function editItem() {
  emit("edit", props.item);
}

function deleteItem() {
  if (confirm("Tem certeza que deseja excluir este item?")) {
    // Call the delete function from the parent component
    emit("delete", props.item.id);
  }
}
</script>

<style scoped>
.item-card {
  transition: all 0.3s ease;
  animation: fadeIn 0.5s;
}

.item-card:hover {
  transform: translateY(-2px);
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
