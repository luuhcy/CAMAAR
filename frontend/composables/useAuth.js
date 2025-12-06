import { ref } from 'vue';

const user = ref(null); 
const isLoggedIn = ref(false);

export const useAuth = () => {
    
    const login = async (email, password) => {
        
        try {
            const response = await $fetch('/api/auth/login', {
                method: 'POST',
                body: { email, password },
            });
            
            user.value = {
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