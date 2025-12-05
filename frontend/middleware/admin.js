export default defineNuxtRouteMiddleware((to, from) => {
    if (process.client) {
        const isAuthenticated = localStorage.getItem('isAuthenticated') === 'true';
        const userRole = localStorage.getItem('userRole');

        if (!isAuthenticated) {
            return navigateTo('/login');
        }

        if (userRole !== 'admin') {
            return navigateTo('/avaliacoes'); 
        }
    }
});