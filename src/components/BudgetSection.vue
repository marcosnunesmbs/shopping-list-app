<template>
  <div
    class="budget-container w-full h-1/4 fixed top-0 left-0 right-0 p-4 shadow-md flex flex-col items-center justify-center"
    :class="{
      'bg-red-100': balanceIsNegative,
      'bg-green-100': !balanceIsNegative,
    }"
  >
    <div
      class="amount-display text-4xl font-bold mb-1"
      :class="{
        'text-red-600': balanceIsNegative,
        'text-green-600': !balanceIsNegative,
      }"
    >
      {{ balanceIsNegative ? "-" : "" }} R$ {{ formattedBalance }}
    </div>
    <div class="budget text-gray-600 text-sm mb-4">
      R$ {{ formattedBudget }}
    </div>
    <button
      @click="openBudgetModal"
      class="btn btn-xs"
      :class="{
        'bg-red-200': balanceIsNegative,
        'bg-green-200': !balanceIsNegative,
      }"
    >
      Ajustar Orçamento
    </button>
  </div>

  <!-- Budget Modal -->
  <div
    v-if="isBudgetModalOpen"
    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
  >
    <div class="bg-white p-6 rounded-lg shadow-lg w-80">
      <h2 class="text-xl font-bold mb-4">Ajustar Orçamento</h2>
      <div class="mb-4">
        <label class="block text-gray-700 mb-2" for="budget"
          >Valor do Orçamento</label
        >
        <div class="flex items-center">
          <span class="mr-2">R$</span>
          <input
            type="number"
            id="budget"
            v-model="newBudget"
            class="w-full p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
          />
        </div>
      </div>
      <div class="flex justify-end space-x-2">
        <button
          @click="closeBudgetModal"
          class="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-100"
        >
          Cancelar
        </button>
        <button
          @click="saveBudget"
          class="px-4 py-2 bg-success text-white rounded-md hover:bg-green-700"
        >
          Salvar
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";

const props = defineProps({
  totalExpenses: {
    type: Number,
    default: 0,
  },
});

const emit = defineEmits(["update-budget"]);

const budget = ref(100);
const isBudgetModalOpen = ref(false);
const newBudget = ref(100);

const balance = computed(() => {
  return budget.value - props.totalExpenses;
});

const balanceIsNegative = computed(() => {
  return balance.value < 0;
});

const formattedBalance = computed(() => {
  return Math.abs(balance.value).toFixed(2).replace(".", ",");
});

const formattedBudget = computed(() => {
  return budget.value.toFixed(2).replace(".", ",");
});

function openBudgetModal() {
  newBudget.value = budget.value;
  isBudgetModalOpen.value = true;
}

function closeBudgetModal() {
  isBudgetModalOpen.value = false;
}

function saveBudget() {
  budget.value = Number(newBudget.value);
  localStorage.setItem("shopping-budget", budget.value);
  emit("update-budget", budget.value);
  closeBudgetModal();
}

onMounted(() => {
  const savedBudget = localStorage.getItem("shopping-budget");
  if (savedBudget) {
    budget.value = Number(savedBudget);
  }
});
</script>

<style scoped>
.budget-container {
  z-index: 10;
}
</style>
