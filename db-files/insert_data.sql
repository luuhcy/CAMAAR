-- Inserção dos dados no banco CAMAAR v2

-- Inserir turmas
INSERT INTO turma (cod_sigaa, semestre, disciplina, nome, ano) VALUES 
('CIC0097', '2021.2', 'BANCOS DE DADOS', 'TA', 2021),
('CIC0105', '2021.2', 'ENGENHARIA DE SOFTWARE', 'TA', 2021),
('CIC0202', '2021.2', 'PROGRAMAÇÃO CONCORRENTE', 'TA', 2021);

-- Inserir docente
INSERT INTO usuario (senha, email, matricula, nome, tipo_usuario, admin, user) VALUES 
('senha123', 'mholanda@unb.br', NULL, 'MARISTELA TERTO DE HOLANDA', 'docente', 1, '83807519491');

-- Inserir discentes
INSERT INTO usuario (senha, email, matricula, nome, tipo_usuario, admin, user) VALUES 
('senha123', 'acjpjvjp@gmail.com', '190084006', 'Ana Clara Jordao Perna', 'discente', 0, '190084006'),
('senha123', 'andreCarvalhoroure@gmail.com', '200033522', 'Andre Carvalho de Roure', 'discente', 0, '200033522'),
('senha123', 'andre.acm97@outlook.com', '150005491', 'André Carvalho Marques', 'discente', 0, '150005491'),
('senha123', 'antoniovmoura.r@gmail.com', '190084502', 'Antonio Vinicius de Moura Rodrigues', 'discente', 0, '190084502'),
('senha123', 'arthurbarreirosmota@gmail.com', '190102829', 'Arthur Barreiros de Oliveira Mota', 'discente', 0, '190102829'),
('senha123', 'arthurcontroleambiental@gmail.com', '202014403', 'ARTHUR RODRIGUES NEVES', 'discente', 0, '202014403'),
('senha123', 'biancaglyciaboueri@gmail.com', '170161561', 'Bianca Glycia Boueri', 'discente', 0, '170161561'),
('senha123', 'peluticaio@gmail.com', '190085312', 'Caio Otávio Peluti Alencar', 'discente', 0, '190085312'),
('senha123', 'camilizx2021@gmail.com', '170007561', 'Camila Frealdo Fraga', 'discente', 0, '170007561'),
('senha123', 'dinhobarros15@gmail.com', '190097591', 'Claudio Roberto Oliveira Peres de Barros', 'discente', 0, '190097591'),
('senha123', 'daltroov777@gmail.com', '160025966', 'Daltro Oliveira Vinuto', 'discente', 0, '160025966'),
('senha123', 'davimouraamaral@gmail.com', '200016750', 'Davi de Moura Amaral', 'discente', 0, '200016750'),
('senha123', 'eduardoxdantas@gmail.com', '190086530', 'Eduardo Xavier Dantas', 'discente', 0, '190086530'),
('senha123', 'enzonleal2016@hotmail.com', '190062789', 'Enzo Nunes Leal Sampaio', 'discente', 0, '190062789'),
('senha123', 'enzoyn@hotmail.com', '190027304', 'Enzo Yoshio Niho', 'discente', 0, '190027304'),
('senha123', 'gabrielfaustino99@gmail.com', '190013249', 'Gabriel Faustino Lima da Rocha', 'discente', 0, '190013249'),
('senha123', 'gabriel.ligoski@gmail.com', '190087498', 'Gabriel Ligoski', 'discente', 0, '190087498'),
('senha123', 'gabrielciriatico@gmail.com', '202033202', 'GABRIEL MENDES CIRIATICO GUIMARÃES', 'discente', 0, '202033202'),
('senha123', '190014121@aluno.unb.br', '190014121', 'Gustavo Rodrigues dos Santos', 'discente', 0, '190014121'),
('senha123', 'gustavorgualberto@gmail.com', '190108266', 'Gustavo Rodrigues Gualberto', 'discente', 0, '190108266'),
('senha123', 'igordavid13@gmail.com', '180102141', 'Igor David Morais', 'discente', 0, '180102141'),
('senha123', 'ndaffte@gmail.com', '180057570', 'Jefte Augusto Gomes Batista', 'discente', 0, '180057570'),
('senha123', 'karolinasouza@outlook.com', '190046791', 'Karolina de Souza Silva', 'discente', 0, '190046791'),
('senha123', 'kleberrjr7@gmail.com', '200053680', 'Kléber Rodrigues da Costa Júnior', 'discente', 0, '200053680'),
('senha123', 'barbadluca@gmail.com', '180125559', 'Luca Delpino Barbabella', 'discente', 0, '180125559'),
('senha123', 'lucasaafaria@gmail.com', '170016668', 'Lucas de Almeida Abreu Faria', 'discente', 0, '170016668'),
('senha123', 'lucasramalho29@gmail.com', '190098091', 'Lucas Gonçalves Ramalho', 'discente', 0, '190098091'),
('senha123', 'luquinha_miranda@hotmail.com', '170149684', 'Lucas Monteiro Miranda', 'discente', 0, '170149684'),
('senha123', '180144421@aluno.unb.br', '180144421', 'Lucas Resende Silveira Reis', 'discente', 0, '180144421'),
('senha123', 'lflamellas@icloud.com', '190016841', 'Luis Fernando Freitas Lamellas', 'discente', 0, '190016841'),
('senha123', 'luizangomes@outlook.com', '190112794', 'Luiza de Araujo Nunes Gomes', 'discente', 0, '190112794'),
('senha123', '180126652@aluno.unb.br', '180126652', 'Marcelo Aiache Postiglione', 'discente', 0, '180126652'),
('senha123', 'marcelojunqueiraf@gmail.com', '200023624', 'Marcelo Junqueira Ferreira', 'discente', 0, '200023624'),
('senha123', 'auntduda@gmail.com', '190092556', 'MARIA EDUARDA CARVALHO SANTOS', 'discente', 0, '190092556'),
('senha123', 'lacwerda@gmail.com', '200067184', 'Maria Eduarda Lacerda Dantas', 'discente', 0, '200067184'),
('senha123', 'mayllak@hotmail.com', '190043873', 'Maylla Krislainy de Sousa Silva', 'discente', 0, '190043873'),
('senha123', 'pedrocesarribeiro2013@gmail.com', '180139312', 'Pedro Cesar Ribeiro Passos', 'discente', 0, '180139312'),
('senha123', '170021041@aluno.unb.br', '170021041', 'Rafael Mascarenhas Dal Moro', 'discente', 0, '170021041'),
('senha123', 'arrelaro1@hotmail.com', '190095164', 'Rodrigo Mamedio Arrelaro', 'discente', 0, '190095164'),
('senha123', 'thiago.work.ti@outlook.com', '140177442', 'Thiago de Oliveira Albuquerque', 'discente', 0, '140177442'),
('senha123', 'thiagoeliasdosreis01@gmail.com', '190126892', 'Thiago Elias dos Reis', 'discente', 0, '190126892'),
('senha123', 'aluno0sem.luz@gmail.com', '180132041', 'Victor Hugo Rodrigues Fernandes', 'discente', 0, '180132041'),
('senha123', 'viniciuslimapassos@gmail.com', '200028545', 'Vinicius Lima Passos', 'discente', 0, '200028545'),
('senha123', 'wilxavier@me.com', '190075384', 'William Xavier dos Santos', 'discente', 0, '190075384');

-- Relacionar docente com turma CIC0097 (id_turma = 1, usuario_id = 1)
INSERT INTO usuario_turma (usuario_id, turma_id) VALUES (1, 1);

-- Matricular todos os discentes na turma CIC0097 (turma_id = 1)
INSERT INTO usuario_turma (usuario_id, turma_id) 
SELECT id, 1 FROM usuario WHERE tipo_usuario = 'discente';