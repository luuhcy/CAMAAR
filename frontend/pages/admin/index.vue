<template>
  <AdminLayout :active-menu-id="activeMenuId" @menu-change="changeMenu">
    
    <template #default="{ activeId }">
      
      <ListaDeCards v-if="activeId === 'avaliacoes'" />
      
      <GerenciamentoDeUsuarios v-else-if="activeId === 'gerenciamento'" />
      
      <div v-else class="fallback-message">
        <p>Selecione uma opção no menu lateral para iniciar o gerenciamento.</p>
      </div>
    </template>
  </AdminLayout>
</template>

<script setup>
import { ref } from 'vue';
import AdminLayout from '~/components/AdminLayout.vue';
import ListaDeCards from '~/components/ListaDeCards.vue'; 
import GerenciamentoDeUsuarios from '~/components/GerenciamentoDeUsuarios.vue'; 

const activeMenuId = ref('avaliacoes'); 

const changeMenu = (id) => {
  activeMenuId.value = id;
};

definePageMeta({
  middleware: ['admin'] 
});
</script>

<style scoped>
.fallback-message {
    padding: 20px;
    background: white;
    border-radius: 8px;
    width: 100%;
    max-width: 800px;
    text-align: center;
}
</style>