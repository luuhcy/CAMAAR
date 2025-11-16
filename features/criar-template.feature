Feature: Criar template de formulário
  Como Administrador
  Quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

  Scenario: Criar template de formulário com sucesso
    Given que o administrador está logado na página de formulários
    When o administrador preenche o nome do template e as questões
    Then o sistema salva o novo template de formulário
    And exibe uma mensagem de confirmação que o template foi criado

  Scenario: Falha ao criar o template por campos obrigatórios vazios
    Given que o administrador está logado na página de formulários
    When o administrador tenta criar um template sem preencher todos os campos obrigatórios
    Then o sistema impede a criação do template de formulário
    And o sistema exibe uma mensagem informando que é necessário preencher todos os campos obrigatórios

