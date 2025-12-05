export const useDatabase = () => {
  const turmas = ref([
    { 
      id: 1, 
      cod_sigaa: 'CIC0097',
      disciplina: 'BANCOS DE DADOS', 
      semestre: '2021.2', 
      professor: 'MARISTELA TERTO DE HOLANDA',
      nome: 'TA',
      ano: 2021
    },
    { 
      id: 2, 
      cod_sigaa: 'CIC0105',
      disciplina: 'ENGENHARIA DE SOFTWARE', 
      semestre: '2021.2', 
      professor: 'MARISTELA TERTO DE HOLANDA',
      nome: 'TA',
      ano: 2021
    },
    { 
      id: 3, 
      cod_sigaa: 'CIC0202',
      disciplina: 'PROGRAMAÇÃO CONCORRENTE', 
      semestre: '2021.2', 
      professor: 'MARISTELA TERTO DE HOLANDA',
      nome: 'TA',
      ano: 2021
    }
  ])

  const usuarios = ref([
    {
      id: 1,
      nome: 'MARISTELA TERTO DE HOLANDA',
      email: 'mholanda@unb.br',
      tipo_usuario: 'docente',
      admin: true
    }
  ])

  const getTurmas = () => turmas.value
  const getUsuarios = () => usuarios.value
  const getTurmaById = (id) => turmas.value.find(t => t.id === id)

  return {
    turmas: readonly(turmas),
    usuarios: readonly(usuarios),
    getTurmas,
    getUsuarios,
    getTurmaById
  }
}