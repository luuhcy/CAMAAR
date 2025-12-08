<template>
  <div class="redirecionando-loading">Redirecionando para Login...</div>
</template>

<script setup>
import { onMounted } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();

onMounted(() => {
    router.push('/login');
});
</script>

<style scoped>
.redirecionando-loading {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    font-family: sans-serif;
    color: #6C2365;
    font-size: 1.5rem;
}
</style>