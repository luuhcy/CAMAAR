<template>
  <div class="layout-container">
    <header class="navbar">
      <div class="left-section">
        <div class="hamburger-icon" @click="toggleSidebar">☰</div>
        <h2 class="page-title">Avaliações</h2>
      </div>

      <div class="right-section">
        <div class="search-bar-container">
          <input type="text" placeholder="" />
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="search-icon">
            <path d="M11 19C15.4183 19 19 15.4183 19 11C19 6.58172 15.4183 3 11 3C6.58172 3 3 6.58172 3 11C3 15.4183 6.58172 19 11 19Z" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M21 21L16.65 16.65" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        
        <div class="profile-area">
          <div class="user-avatar" @click="toggleDropdown">U</div>
          <div class="dropdown-menu" v-if="isDropdownOpen">
            <a href="#" class="logout-btn" @click.prevent="handleLogout">Logout</a>
          </div>
        </div>
      </div>
    </header>

    <div class="body-content">
      <aside class="sidebar" :class="{ 'sidebar-closed': !isSidebarOpen }">
        <nav>
          <ul>
            <li class="active">Avaliações</li>
          </ul>
        </nav>
      </aside>
    
      <main class="main-content-area">
        <div class="grid-container">
          <div 
            v-for="materia in materias" 
            :key="materia.id" 
            class="card"
            @click="openAvaliacao(materia.id)"
          >
            <div class="card-content">
              <h3 class="subject-name">{{ materia.nome }}</h3>
              <span class="semestre">{{ materia.semestre }}</span>
              <p class="professor">{{ materia.professor }}</p>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

definePageMeta({
  middleware: ['auth'] 
});

const router = useRouter();
const isSidebarOpen = ref(false);
const isDropdownOpen = ref(false);

const toggleSidebar = () => {
  isSidebarOpen.value = !isSidebarOpen.value;
};

const toggleDropdown = () => {
    isDropdownOpen.value = !isDropdownOpen.value;
};

const handleLogout = () => {
    localStorage.removeItem('isAuthenticated');
    localStorage.removeItem('userRole');
    router.push('/login');
};

const openAvaliacao = (id) => {
    router.push(`/formulario/${id}`);
};

const materias = [
  { id: 1, nome: "Introdução à Computação", semestre: "2023.2", professor: "Prof. Silva" },
  { id: 2, nome: "Cálculo I", semestre: "2024.1", professor: "Prof. Souza" },
  { id: 3, nome: "Algoritmos", semestre: "2024.1", professor: "Prof. Santos" },
  { id: 4, nome: "Estrutura de Dados", semestre: "2023.2", professor: "Prof. Oliveira" },
  { id: 5, nome: "Redes de Computadores", semestre: "2024.1", professor: "Prof. Costa" }
];
</script>

<style scoped>
* { box-sizing: border-box; }
body { margin: 0; }

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

.dropdown-menu {
  position: absolute;
  top: 45px; 
  right: 0;
  background: white;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  min-width: 100px;
  z-index: 10;
}

.logout-btn {
  display: block;
  padding: 10px 15px;
  text-decoration: none;
  color: #333;
  font-size: 15px;
}
.logout-btn:hover {
  background: #f0f0f0;
}

.body-content {
  display: flex;
  flex: 1; 
  overflow: hidden;
}

.sidebar {
  width: 180px; 
  background-color: white; 
  transition: width 0.3s ease;
  overflow: hidden;
}

.sidebar-closed {
  width: 0 !important;
  padding: 0 !important;
}

nav ul { list-style: none; padding: 0; margin: 0; }
nav li {
  padding: 15px 20px;
  cursor: pointer;
  color: #333; 
  font-weight: 500;
  border-left: 5px solid transparent; 
  font-size: 16px;
  white-space: nowrap;
}
nav li.active {
  background-color: #6C2365;
  color: white;
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

.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); 
  gap: 25px;
  width: 100%;
  max-width: 1200px; 
}

.card {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  height: 100px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  cursor: pointer;
}
.card-content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  height: 100%;
}

.subject-name { 
  margin: 0 0 5px 0; 
  font-size: 1.1rem; 
  font-weight: bold; 
  color: #333; 
}
.semestre { 
  font-size: 0.8rem; 
  color: #666; 
  display: block; 
  margin-bottom: 5px; 
}
.professor { 
  font-weight: bold; 
  margin: 0; 
  font-size: 1rem; 
  color: #333; 
}
</style>