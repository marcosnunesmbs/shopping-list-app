<script setup>
import { ref, computed, onMounted } from "vue";
import BudgetSection from "./components/BudgetSection.vue";
import ShoppingItem from "./components/ShoppingItem.vue";
import AddItemButton from "./components/AddItemButton.vue";

const items = ref([]);
const addItemRef = ref(null);

const totalExpenses = computed(() => {
  return items.value.reduce((sum, item) => sum + item.total, 0);
});

function addItem(newItem) {
  items.value.push(newItem);
  saveItemsToLocalStorage();
}

function updateItem(updatedItem) {
  const index = items.value.findIndex((item) => item.id === updatedItem.id);
  if (index !== -1) {
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

function saveItemsToLocalStorage() {
  localStorage.setItem("shopping-items", JSON.stringify(items.value));
}

onMounted(() => {
  const savedItems = localStorage.getItem("shopping-items");
  if (savedItems) {
    items.value = JSON.parse(savedItems);
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
      />
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
