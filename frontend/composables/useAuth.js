import { ref } from 'vue';

const user = ref(null); 
const isLoggedIn = ref(false);

export const useAuth = () => {
    
    // Inicializar user do localStorage se estiver logado
    if (process.client && localStorage.getItem('isAuthenticated') === 'true') {
        user.value = {
            id: Number.parseInt(localStorage.getItem('userId')) || null,
            nome: localStorage.getItem('userName'),
            email: localStorage.getItem('userEmail'),
            tipo: localStorage.getItem('userRole'),
        };
        isLoggedIn.value = true;
    }
    
    const login = async (email, password) => {
        
        try {
            const response = await $fetch('/api/auth/login', {
                method: 'POST',
                body: { email, password },
            });
            
            user.value = {
                id: response.id,
                tipo: response.tipo,
                nome: response.nome,
                email: response.email,
            };
            isLoggedIn.value = true;
            
            return user.value;
            
        } catch (e) {
            user.value = null;
            isLoggedIn.value = false;
            throw e; 
        }
    };

    const logout = () => {
        user.value = null;
        isLoggedIn.value = false;
    };

    return {
        user,
        isLoggedIn,
        login,
        logout,
    };
};