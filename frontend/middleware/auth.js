export default defineNuxtRouteMiddleware((to, from) => {
    if (process.client) {
        const isAuthenticated = localStorage.getItem('isAuthenticated') === 'true';

        if (!isAuthenticated && to.path !== '/login' && to.path !== '/cadastro') {
            return navigateTo('/login');
        }

        if (isAuthenticated && (to.path === '/login' || to.path === '/cadastro')) {
            const userRole = localStorage.getItem('userRole');
            
            if (userRole === 'admin') {
                return navigateTo('/admin');
            } else {
                return navigateTo('/avaliacoes');
            }
        }
    }
});