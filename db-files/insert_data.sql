-- Inserção dos dados no banco CAMAAR

-- Inserir disciplinas
INSERT INTO disciplinas (code, name) VALUES 
('CIC0097', 'BANCOS DE DADOS'),
('CIC0105', 'ENGENHARIA DE SOFTWARE'),
('CIC0202', 'PROGRAMAÇÃO CONCORRENTE');

-- Inserir turmas
INSERT INTO turmas (disciplina_code, class_code, semester, time) VALUES 
('CIC0097', 'TA', '2021.2', '35T45'),
('CIC0105', 'TA', '2021.2', '35M12'),
('CIC0202', 'TA', '2021.2', '35M34');

-- Inserir docente
INSERT INTO docentes (usuario, nome, departamento, formacao, email, ocupacao) VALUES 
('83807519491', 'MARISTELA TERTO DE HOLANDA', 'DEPTO CIÊNCIAS DA COMPUTAÇÃO', 'DOUTORADO', 'mholanda@unb.br', 'docente');

-- Inserir discentes da turma CIC0097-TA
INSERT INTO discentes (matricula, nome, curso, usuario, formacao, ocupacao, email) VALUES 
('190084006', 'Ana Clara Jordao Perna', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190084006', 'graduando', 'dicente', 'acjpjvjp@gmail.com'),
('200033522', 'Andre Carvalho de Roure', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '200033522', 'graduando', 'dicente', 'andreCarvalhoroure@gmail.com'),
('150005491', 'André Carvalho Marques', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '150005491', 'graduando', 'dicente', 'andre.acm97@outlook.com'),
('190084502', 'Antonio Vinicius de Moura Rodrigues', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190084502', 'graduando', 'dicente', 'antoniovmoura.r@gmail.com'),
('190102829', 'Arthur Barreiros de Oliveira Mota', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190102829', 'graduando', 'dicente', 'arthurbarreirosmota@gmail.com'),
('202014403', 'ARTHUR RODRIGUES NEVES', 'ENGENHARIA DE COMPUTAÇÃO/CIC', '202014403', 'graduando', 'dicente', 'arthurcontroleambiental@gmail.com'),
('170161561', 'Bianca Glycia Boueri', 'ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD', '170161561', 'graduando', 'dicente', 'biancaglyciaboueri@gmail.com'),
('190085312', 'Caio Otávio Peluti Alencar', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190085312', 'graduando', 'dicente', 'peluticaio@gmail.com'),
('170007561', 'Camila Frealdo Fraga', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '170007561', 'graduando', 'dicente', 'camilizx2021@gmail.com'),
('190097591', 'Claudio Roberto Oliveira Peres de Barros', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190097591', 'graduando', 'dicente', 'dinhobarros15@gmail.com'),
('160025966', 'Daltro Oliveira Vinuto', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '160025966', 'graduando', 'dicente', 'daltroov777@gmail.com'),
('200016750', 'Davi de Moura Amaral', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '200016750', 'graduando', 'dicente', 'davimouraamaral@gmail.com'),
('190086530', 'Eduardo Xavier Dantas', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190086530', 'graduando', 'dicente', 'eduardoxdantas@gmail.com'),
('190062789', 'Enzo Nunes Leal Sampaio', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190062789', 'graduando', 'dicente', 'enzonleal2016@hotmail.com'),
('190027304', 'Enzo Yoshio Niho', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190027304', 'graduando', 'dicente', 'enzoyn@hotmail.com'),
('190013249', 'Gabriel Faustino Lima da Rocha', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190013249', 'graduando', 'dicente', 'gabrielfaustino99@gmail.com'),
('190087498', 'Gabriel Ligoski', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190087498', 'graduando', 'dicente', 'gabriel.ligoski@gmail.com'),
('202033202', 'GABRIEL MENDES CIRIATICO GUIMARÃES', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '202033202', 'graduando', 'dicente', 'gabrielciriatico@gmail.com'),
('190014121', 'Gustavo Rodrigues dos Santos', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190014121', 'graduando', 'dicente', '190014121@aluno.unb.br'),
('190108266', 'Gustavo Rodrigues Gualberto', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190108266', 'graduando', 'dicente', 'gustavorgualberto@gmail.com'),
('180102141', 'Igor David Morais', 'ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD', '180102141', 'graduando', 'dicente', 'igordavid13@gmail.com'),
('180057570', 'Jefte Augusto Gomes Batista', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '180057570', 'graduando', 'dicente', 'ndaffte@gmail.com'),
('190046791', 'Karolina de Souza Silva', 'ENGENHARIA DE COMPUTAÇÃO/CIC', '190046791', 'graduando', 'dicente', 'karolinasouza@outlook.com'),
('200053680', 'Kléber Rodrigues da Costa Júnior', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '200053680', 'graduando', 'dicente', 'kleberrjr7@gmail.com'),
('180125559', 'Luca Delpino Barbabella', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '180125559', 'graduando', 'dicente', 'barbadluca@gmail.com'),
('170016668', 'Lucas de Almeida Abreu Faria', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '170016668', 'graduando', 'dicente', 'lucasaafaria@gmail.com'),
('190098091', 'Lucas Gonçalves Ramalho', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190098091', 'graduando', 'dicente', 'lucasramalho29@gmail.com'),
('170149684', 'Lucas Monteiro Miranda', 'ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD', '170149684', 'graduando', 'dicente', 'luquinha_miranda@hotmail.com'),
('180144421', 'Lucas Resende Silveira Reis', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '180144421', 'graduando', 'dicente', '180144421@aluno.unb.br'),
('190016841', 'Luis Fernando Freitas Lamellas', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190016841', 'graduando', 'dicente', 'lflamellas@icloud.com'),
('190112794', 'Luiza de Araujo Nunes Gomes', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190112794', 'graduando', 'dicente', 'luizangomes@outlook.com'),
('180126652', 'Marcelo Aiache Postiglione', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '180126652', 'graduando', 'dicente', '180126652@aluno.unb.br'),
('200023624', 'Marcelo Junqueira Ferreira', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '200023624', 'graduando', 'dicente', 'marcelojunqueiraf@gmail.com'),
('190092556', 'MARIA EDUARDA CARVALHO SANTOS', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190092556', 'graduando', 'dicente', 'auntduda@gmail.com'),
('200067184', 'Maria Eduarda Lacerda Dantas', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '200067184', 'graduando', 'dicente', 'lacwerda@gmail.com'),
('190043873', 'Maylla Krislainy de Sousa Silva', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190043873', 'graduando', 'dicente', 'mayllak@hotmail.com'),
('180139312', 'Pedro Cesar Ribeiro Passos', 'ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD', '180139312', 'graduando', 'dicente', 'pedrocesarribeiro2013@gmail.com'),
('170021041', 'Rafael Mascarenhas Dal Moro', 'ENGENHARIA DE COMPUTAÇÃO/CIC', '170021041', 'graduando', 'dicente', '170021041@aluno.unb.br'),
('190095164', 'Rodrigo Mamedio Arrelaro', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190095164', 'graduando', 'dicente', 'arrelaro1@hotmail.com'),
('140177442', 'Thiago de Oliveira Albuquerque', 'ENGENHARIA DE COMPUTAÇÃO/CIC', '140177442', 'graduando', 'dicente', 'thiago.work.ti@outlook.com'),
('190126892', 'Thiago Elias dos Reis', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190126892', 'graduando', 'dicente', 'thiagoeliasdosreis01@gmail.com'),
('180132041', 'Victor Hugo Rodrigues Fernandes', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '180132041', 'graduando', 'dicente', 'aluno0sem.luz@gmail.com'),
('200028545', 'Vinicius Lima Passos', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '200028545', 'graduando', 'dicente', 'viniciuslimapassos@gmail.com'),
('190075384', 'William Xavier dos Santos', 'CIÊNCIA DA COMPUTAÇÃO/CIC', '190075384', 'graduando', 'dicente', 'wilxavier@me.com');

-- Relacionar docente com turma CIC0097-TA
INSERT INTO turma_docente (turma_id, docente_usuario) VALUES 
(1, '83807519491');

-- Matricular todos os discentes na turma CIC0097-TA (turma_id = 1)
INSERT INTO matriculas (turma_id, discente_matricula) 
SELECT 1, matricula FROM discentes;