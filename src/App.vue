<script setup>
import { ref, computed, onMounted } from "vue";
import BudgetSection from "./components/BudgetSection.vue";
import ShoppingItem from "./components/ShoppingItem.vue";
import AddItemButton from "./components/AddItemButton.vue";

const items = ref([]);
const addItemRef = ref(null);
const showDeleteAllModal = ref(false);

const totalExpenses = computed(() => {
  return items.value.reduce((sum, item) => sum + item.total, 0);
});

function addItem(newItem) {
  // Adiciona a propriedade 'checked' ao novo item
  newItem.checked = false;
  items.value.push(newItem);
  saveItemsToLocalStorage();
}

function updateItem(updatedItem) {
  const index = items.value.findIndex((item) => item.id === updatedItem.id);
  if (index !== -1) {
    // Preserva o estado 'checked' ao atualizar o item
    updatedItem.checked = items.value[index].checked;
    items.value[index] = updatedItem;
    saveItemsToLocalStorage();
  }
}

function editItem(item) {
  addItemRef.value.openEditModal(item);
}

function deleteItem(itemId) {
  items.value = items.value.filter((item) => item.id !== itemId);
  saveItemsToLocalStorage();
}

function toggleCheck(itemId) {
  const item = items.value.find((item) => item.id === itemId);
  if (item) {
    item.checked = !item.checked;
    saveItemsToLocalStorage();
  }
}

function openDeleteAllModal() {
  showDeleteAllModal.value = true;
}

function closeDeleteAllModal() {
  showDeleteAllModal.value = false;
}

function deleteAllItems() {
  items.value = [];
  saveItemsToLocalStorage();
  closeDeleteAllModal();
}

function saveItemsToLocalStorage() {
  localStorage.setItem("shopping-items", JSON.stringify(items.value));
}

onMounted(() => {
  const savedItems = localStorage.getItem("shopping-items");
  if (savedItems) {
    items.value = JSON.parse(savedItems);
    // Garante que todos os itens tenham a propriedade 'checked'
    items.value = items.value.map(item => ({
      ...item,
      checked: item.checked || false
    }));
  }
});
</script>

<template>
  <div class="shopping-list-app min-h-screen">
    <BudgetSection :totalExpenses="totalExpenses" />

    <div
      class="items-container pt-[calc(20vh+15px)] px-4 pb-24 max-w-md mx-auto"
    >
      <div v-if="items.length === 0" class="text-center py-10 text-gray-500">
        Nenhum item adicionado. Use o botão + para adicionar itens.
      </div>

      <ShoppingItem
        v-for="item in items"
        :key="item.id"
        :item="item"
        @edit="editItem"
        @delete="deleteItem"
        @toggle-check="toggleCheck"
      />

      <!-- Botão Excluir Tudo -->
      <div v-if="items.length > 0" class="mt-4 text-center">
        <button
          @click="openDeleteAllModal"
          class="px-4 py-2 bg-error text-white rounded-md hover:bg-red-700 transition-colors"
        >
          Excluir Tudo
        </button>
      </div>
    </div>

    <!-- Modal Excluir Tudo -->
    <div
      v-if="showDeleteAllModal"
      class="fixed inset-0 flex items-center justify-center z-50"
      style="background-color: rgba(0, 0, 0, 0.8)"
    >
      <div class="bg-white p-6 rounded-lg shadow-lg w-80">
        <h2 class="text-xl font-bold mb-4">Confirmar Exclusão</h2>
        <p class="mb-6">
          Tem certeza que deseja excluir todos os itens da lista?
        </p>
        <div class="flex justify-end space-x-2">
          <button
            @click="closeDeleteAllModal"
            class="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-100"
          >
            Cancelar
          </button>
          <button
            @click="deleteAllItems"
            class="px-4 py-2 bg-error text-white rounded-md hover:bg-red-700"
          >
            Excluir Tudo
          </button>
        </div>
      </div>
    </div>

    <AddItemButton
      ref="addItemRef"
      @add-item="addItem"
      @update-item="updateItem"
    />
  </div>
</template>

<style>
body {
  margin: 0;
  padding: 0;
}
</style>
