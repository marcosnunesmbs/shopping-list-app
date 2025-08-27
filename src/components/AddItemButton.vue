<template>
  <div class="fixed bottom-6 right-6">
    <button
      @click="openModal"
      class="w-12 h-12 bg-success hover:bg-success-200 text-white rounded-full flex items-center justify-center shadow-lg transition-transform transform hover:scale-105"
      title="Adicionar Item"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-6 w-6"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M12 4v16m8-8H4"
        />
      </svg>
    </button>
  </div>

  <!-- Add/Edit Item Modal -->
  <div
    v-if="isModalOpen"
    class="fixed inset-0 flex items-center justify-center z-50"
    style="background-color: rgba(0, 0, 0, 0.8)"
  >
    <div class="bg-white p-6 rounded-lg shadow-lg w-80">
      <h2 class="text-xl font-bold mb-4">
        {{ editMode ? "Editar Item" : "Adicionar Item" }}
      </h2>

      <div class="mb-4">
        <label class="block text-neutral mb-2" for="item-name"
          >Nome do Item</label
        >
        <input
          type="text"
          id="item-name"
          v-model="item.name"
          class="w-full p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
          placeholder="Digite o nome do produto"
        />
      </div>

      <div class="mb-4">
        <label class="block text-neutral mb-2" for="item-quantity"
          >Quantidade</label
        >
        <input
          type="number"
          id="item-quantity"
          v-model="item.quantity"
          min="1"
          class="w-full p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
        />
      </div>

      <div class="mb-6">
        <label class="block text-neutral mb-2" for="item-price"
          >Valor Unitário (R$)</label
        >
        <input
          type="number"
          id="item-price"
          v-model="item.unitPrice"
          step="0.01"
          min="0.01"
          class="w-full p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
        />
      </div>

      <div class="mb-4 text-right text-gray-600">
        <strong>Total: {{ calculateTotal }}</strong>
      </div>

      <div class="flex justify-end space-x-2">
        <button
          @click="closeModal"
          class="px-4 py-2 text-neutral border border-gray-300 rounded-md hover:bg-gray-100"
        >
          Cancelar
        </button>
        <button
          @click="saveItem"
          class="px-4 py-2 bg-success text-white rounded-md hover:bg-green-700"
          :disabled="!isFormValid"
        >
          {{ editMode ? "Atualizar" : "Adicionar" }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive } from "vue";

const props = defineProps({
  editingItem: {
    type: Object,
    default: null,
  },
});

const emit = defineEmits(["add-item", "update-item"]);

const isModalOpen = ref(false);
const editMode = ref(false);
const item = reactive({
  id: "",
  name: "",
  quantity: 1,
  unitPrice: 0,
  total: 0,
});

const calculateTotal = computed(() => {
  const total = item.quantity * item.unitPrice;
  return formatCurrency(total);
});

function formatCurrency(value) {
  return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
}

const isFormValid = computed(() => {
  return item.name;
});

function resetForm() {
  item.id = "";
  item.name = "";
  item.quantity = 1;
  item.unitPrice = 0;
}

function openModal() {
  resetForm();
  editMode.value = false;
  isModalOpen.value = true;
}

function closeModal() {
  isModalOpen.value = false;
}

function saveItem() {
  if (!isFormValid.value) return;

  const itemToSave = {
    id: editMode.value ? item.id : Date.now().toString(),
    name: item.name,
    quantity: Number(item.quantity),
    unitPrice: Number(item.unitPrice),
    total: Number(item.quantity) * Number(item.unitPrice),
  };

  if (editMode.value) {
    emit("update-item", itemToSave);
  } else {
    emit("add-item", itemToSave);
  }

  closeModal();
}

function openEditModal(itemToEdit) {
  editMode.value = true;
  item.id = itemToEdit.id;
  item.name = itemToEdit.name;
  item.quantity = itemToEdit.quantity;
  item.unitPrice = itemToEdit.unitPrice;
  isModalOpen.value = true;
}

// Expose the method to parent component
defineExpose({
  openEditModal,
});
</script>
