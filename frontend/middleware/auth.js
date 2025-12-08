// frontend/middleware/auth.js

export default defineNuxtRouteMiddleware((to, from) => {
    if (process.client) {
        const isAuthenticated = localStorage.getItem('isAuthenticated') === 'true';
        const userRole = localStorage.getItem('userRole');

        if (!isAuthenticated && to.path !== '/login' && to.path !== '/cadastro') {
            return navigateTo('/login');
        }

        if (isAuthenticated && (to.path === '/login' || to.path === '/cadastro')) {
            
            if (userRole === 'admin') {
                return navigateTo('/admin');
            } else {
                return navigateTo('/avaliacoes');
            }
        }
    }
});