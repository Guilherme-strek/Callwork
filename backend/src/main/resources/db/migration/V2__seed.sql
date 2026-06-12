-- V2: dados de exemplo

INSERT INTO professionals (name, role, category, city, about, cnpj, mei_verified, rating, reviews_count) VALUES
('Ana Moura',     'Diarista',            'Limpeza',    'Maringa, PR', 'Diarista com 6 anos de experiencia em limpeza residencial e comercial. Pontual e com produtos proprios.', '12.345.678/0001-90', TRUE, 4.9, 132),
('Carlos Reis',   'Eletricista',         'Reformas',   'Maringa, PR', 'Eletricista predial e residencial. Instalacoes, manutencao e laudos. Atende emergencias.',                 '23.456.789/0001-01', TRUE, 4.8, 87),
('Julia Souza',   'Designer freelancer', 'Tecnologia', 'Remoto',      'Designer grafica focada em identidade visual para pequenos negocios.',                                      NULL,                 FALSE,5.0, 41),
('Rosa Lima',     'Diarista',            'Limpeza',    'Maringa, PR', 'Diarista atenta aos detalhes, especializada em limpeza pesada e organizacao de ambientes.',                 '34.567.890/0001-12', TRUE, 4.7, 64),
('Clara Freitas', 'Manicure',            'Beleza',     'Maringa, PR', 'Manicure e designer de sobrancelhas com atendimento a domicilio.',                                          '45.678.901/0001-23', TRUE, 4.8, 91);

INSERT INTO services (professional_id, title, price_cents, active) VALUES
((SELECT id FROM professionals WHERE name = 'Ana Moura'), 'Limpeza residencial', 12000, TRUE),
((SELECT id FROM professionals WHERE name = 'Ana Moura'), 'Limpeza pos-obra',    18000, TRUE),
((SELECT id FROM professionals WHERE name = 'Ana Moura'), 'Limpeza comercial',   15000, FALSE),
((SELECT id FROM professionals WHERE name = 'Carlos Reis'), 'Instalacao de tomadas', 9000, TRUE),
((SELECT id FROM professionals WHERE name = 'Carlos Reis'), 'Troca de disjuntor',  12000, TRUE),
((SELECT id FROM professionals WHERE name = 'Carlos Reis'), 'Laudo eletrico',      25000, TRUE),
((SELECT id FROM professionals WHERE name = 'Julia Souza'), 'Logo + manual de marca', 45000, TRUE),
((SELECT id FROM professionals WHERE name = 'Julia Souza'), 'Kit social media',    28000, TRUE),
((SELECT id FROM professionals WHERE name = 'Rosa Lima'), 'Limpeza residencial', 11000, TRUE),
((SELECT id FROM professionals WHERE name = 'Rosa Lima'), 'Faxina pesada',       16000, TRUE),
((SELECT id FROM professionals WHERE name = 'Clara Freitas'), 'Maos e pes',           6000, TRUE),
((SELECT id FROM professionals WHERE name = 'Clara Freitas'), 'Design de sobrancelha', 4000, TRUE);

INSERT INTO reviews (professional_id, author, rating, comment) VALUES
((SELECT id FROM professionals WHERE name = 'Ana Moura'), 'Padaria do Bairro', 5, 'Pontual e caprichosa, contratei de novo sem pensar duas vezes.'),
((SELECT id FROM professionals WHERE name = 'Ana Moura'), 'TechLocal MEI',     5, 'Otimo trabalho na limpeza do nosso escritorio. Recomendo!'),
((SELECT id FROM professionals WHERE name = 'Carlos Reis'), 'Mercado Central',   5, 'Resolveu o problema eletrico rapidinho.'),
((SELECT id FROM professionals WHERE name = 'Rosa Lima'), 'Condominio Jardim', 4, 'Trabalho bem feito, voltarei a chamar.');

INSERT INTO service_requests (professional_id, requester_name, service_title, message, status) VALUES
((SELECT id FROM professionals WHERE name = 'Ana Moura'), 'Padaria do Bairro', 'Limpeza comercial', 'Voce atende sexta as 14h?', 'PENDING'),
((SELECT id FROM professionals WHERE name = 'Ana Moura'), 'TechLocal MEI',     'Limpeza pos-obra',  'Confirmado para segunda 9h.', 'CONFIRMED');
