<template>
  <div class="layout-container">
    <header class="navbar">
      <div class="left-section">
        <div class="hamburger-icon" @click="toggleSidebar">☰</div>
        <h2 class="page-title">{{ activeItem.nome }}</h2>
      </div>

      <div class="right-section">
        <div class="search-bar-container">
          <input type="text" placeholder="Buscar..." />
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="search-icon">
            <path d="M11 19C15.4183 19 19 15.4183 19 11C19 6.58172 15.4183 3 11 3C6.58172 3 3 6.58172 3 11C3 15.4183 6.58172 19 11 19Z" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M21 21L16.65 16.65" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        
        <div class="profile-area">
          <div class="user-avatar">U</div>
        </div>
      </div>
    </header>

    <div class="body-content">
      <aside class="sidebar">
        <nav>
          <ul>
            <li 
              v-for="item in menuItems" 
              :key="item.id"
              :class="{ 'active': activeItem.id === item.id }"
              @click="$emit('menu-change', item.id)"
            >
              {{ item.nome }}
            </li>
          </ul>
        </nav>
      </aside>
    
      <main class="main-content-area">
        <slot :active-id="activeItem.id"></slot>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';

const props = defineProps({
  activeMenuId: {
    type: String,
    required: true
  }
});

const emit = defineEmits(['menu-change']);

const menuItems = ref([
  { id: 'avaliacoes', nome: 'Avaliações' },
  { id: 'estatisticas', nome: 'Estatísticas' },
  { id: 'importacao', nome: 'Importação' },
]);

const activeItem = computed(() => {
  return menuItems.value.find(item => item.id === props.activeMenuId) || menuItems.value[0];
});

const isSidebarOpen = ref(true); 
const toggleSidebar = () => {
  isSidebarOpen.value = !isSidebarOpen.value;
};
</script>

<style scoped>
* { box-sizing: border-box; }
.layout-container {
    display: flex;
    flex-direction: column;
    height: 100vh;
    font-family: sans-serif;
    background-color: #e0e0e0;
}
.navbar {
    height: 60px;
    background-color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    z-index: 10;
}
.left-section {
    display: flex;
    align-items: center;
    gap: 20px;
}
.hamburger-icon {
    font-size: 1.8rem;
    cursor: pointer;
    color: #333;
}
.page-title {
    margin: 0;
    font-size: 1.5rem;
    color: #333;
    font-weight: 600;
}
.right-section {
    display: flex;
    align-items: center;
    gap: 10px;
}
.search-bar-container {
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    border-radius: 5px;
    background: white;
    width: 250px;
    height: 38px;
    padding: 0 10px;
}
.search-bar-container input {
    border: none;
    outline: none;
    width: 100%;
    font-size: 1rem;
    padding: 0 5px;
}
.search-icon {
    margin-left: 8px;
    min-width: 20px;
    order: 1;
}
.profile-area {
    position: relative;
    display: flex;
    align-items: center;
}
.user-avatar {
    width: 36px; height: 36px;
    background-color: #6C2365;
    color: white;
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-weight: bold; font-size: 1rem;
    cursor: pointer;
}
.body-content {
    display: flex;
    flex: 1;
    overflow: hidden;
}
.sidebar {
    width: 180px;
    background-color: #6C2365;
    transition: width 0.3s ease;
    overflow: hidden;
    color: white;
}
nav ul { list-style: none; padding: 0; margin: 0; }
nav li {
    padding: 15px 20px;
    cursor: pointer;
    color: white;
    font-weight: 500;
    border-left: 5px solid transparent;
    font-size: 16px;
    white-space: nowrap;
}
nav li.active {
    background-color: #8E44AD;
    font-weight: bold;
}
.main-content-area {
    flex: 1;
    background-color: #e0e0e0;
    padding: 30px 40px;
    overflow-y: auto;
    display: flex;
    justify-content: center;
    align-items: flex-start;
}
</style>