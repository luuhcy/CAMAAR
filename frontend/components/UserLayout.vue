<template>
  <button class="fab-button" @click="$emit('click')">
    <slot>Enviar</slot>
  </button>
</template>

<script setup>
const emit = defineEmits(['click']);
</script>

<style scoped>
.fab-button {
  position: fixed;
  bottom: 30px;
  right: 40px;
  width: 60px;
  height: 60px;
  background-color: #8E24AA; 
  color: white;
  border: none;
  border-radius: 50%;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.1rem; 
  font-weight: bold;
  transition: transform 0.2s, background-color 0.2s;
  z-index: 100;
}

.fab-button:hover {
  transform: scale(1.1);
  background-color: #7B1FA2;
}
</style>