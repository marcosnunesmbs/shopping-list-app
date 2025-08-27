<template>
  <div
    class="budget-container w-full h-[20vh] fixed top-0 left-0 right-0 p-4 shadow-md flex flex-col items-center"
    :class="{
      'bg-red-100': hasBudget && balanceIsNegative,
      'bg-green-100': !hasBudget || !balanceIsNegative,
    }"
  >
    <div class="flex-grow flex flex-col items-center justify-center">
      <div
        class="amount-display text-4xl font-bold mb-2"
        :class="{
          'text-red-600': hasBudget && balanceIsNegative,
          'text-green-600': !hasBudget || !balanceIsNegative,
        }"
      >
        <template v-if="hasBudget">
          {{ balanceIsNegative ? "-" : "" }} {{ formattedBalance }}
        </template>
        <template v-else> R$ {{ formattedTotalSpent }} </template>
      </div>
      <div v-if="hasBudget" class="budget text-gray-600 text-sm">
        R$ {{ formattedTotalSpent }} / {{ formattedBudget }}
      </div>
    </div>

    <div class="budget-button-container mt-auto pt-2">
      <button
        @click="openBudgetModal"
        class="btn btn-xs"
        :class="{
          'bg-red-200': hasBudget && balanceIsNegative,
          'bg-green-200': !hasBudget || !balanceIsNegative,
        }"
      >
        {{ hasBudget ? "Ajustar Orçamento" : "Adicionar Orçamento" }}
      </button>
    </div>
  </div>

  <!-- Budget Modal -->
  <div
    v-if="isBudgetModalOpen"
    class="fixed inset-0 flex items-center justify-center z-50"
    style="background-color: rgba(0, 0, 0, 0.8)"
  >
    <div class="bg-white p-6 rounded-lg shadow-lg w-80">
      <h2 class="text-xl font-bold mb-4">
        {{ hasBudget ? "Ajustar Orçamento" : "Adicionar Orçamento" }}
      </h2>
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
        <span class="text-xs">Digite 0 para remover o orçamento.</span>
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

const budget = ref(0);
const isBudgetModalOpen = ref(false);
const newBudget = ref(0);

const hasBudget = computed(() => {
  return budget.value > 0;
});

const balance = computed(() => {
  return budget.value - props.totalExpenses;
});

const balanceIsNegative = computed(() => {
  return balance.value < 0;
});

const formattedBalance = computed(() => {
  return formatCurrency(Math.abs(balance.value));
});

const formattedBudget = computed(() => {
  return formatCurrency(budget.value);
});

function formatCurrency(value) {
  return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });
}

const formattedTotalSpent = computed(() => {
  return formatCurrency(props.totalExpenses);
});

function openBudgetModal() {
  newBudget.value = budget.value;
  isBudgetModalOpen.value = true;
}

function closeBudgetModal() {
  isBudgetModalOpen.value = false;
}

function saveBudget() {
  budget.value = Math.max(0, Number(newBudget.value));
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
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.budget-button-container {
  width: 100%;
  display: flex;
  justify-content: center;
  padding-bottom: 8px;
}
</style>
