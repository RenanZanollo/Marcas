-- Criação da tabela marcas
create table marcas (
mrc_id				int				PRIMARY KEY,
mrc_nome			varchar (50)	NOT NULL,
mrc_nacionalidade	varchar (50)
);

-- Criação da tabela produtos
create table produtos (
prd_id 				int 	PRIMARY KEY,
prd_nome			VARCHAR	NOT NULL,
prd_qtd_estoque		int		NOT NULL 		DEFAULT 0,
prd_estoque_min 	int 	NOT NULL		DEFAULT 0,
prd_data_fabricacao TIMESTAMP	 			DEFAULT CURRENT_TIMESTAMP,
prd_perecivel		boolean,
prd_valor			decimal(10,2),
  
  
prd_marca_id		int, 
constraint fk_marcas FOREIGN KEY (prd_marca_id) REFERENCES marcas(mrc_id)
) ;

-- Criação da tabela fornecedores
create table fornecedores (
frn_id		int 		PRIMARY KEY,
frn_nome	varchar(45)	NOT NULL,
frn_email	varchar(45)
);

-- Criação da tabela produtos_fornecedores
create table produto_fornecedor (
pf_prod_id 	int 		REFERENCES produtos  	(prd_id),
pf_forn_id	int 		REFERENCES fornecedores	(frn_id),
  
primary key (pf_prod_id, pf_forn_id)
);

-- Inserir dados nas tabelas marcas
INSERT INTO marcas (mrc_id, mrc_nome, mrc_nacionalidade) VALUES 
(1,'Marca A', 'Brasil'),
(2,'Marca B', 'EUA'),
(3,'Marca C', 'Alemanha'),
(4,'Marca D', 'França'),
(5,'Marca E', 'Itália'),
(6,'Marca F', 'EUA'),
(7,'Marca G', 'Alemanha'),
(8,'Marca H', 'França');

-- Inserir dados nas tabelas produtos
INSERT INTO produtos (prd_id, prd_nome, prd_qtd_estoque, prd_estoque_min, prd_perecivel, prd_valor, prd_marca_id) VALUES
(1,'Produto 1', 50, 10, true, 15.99, 1),
(2,'Produto 2', 100, 20, false, 25.50, 2),
(3,'Produto 3', 4, 5, true, 10.75, 3),
(4,'Produto 4', 80, 15, false, 35.20, 4),
(5,'Produto 5', 8, 10, true, 20.00, 5),
(6,'Produto 6', 30, 5, true, 10.75, 3),
(7,'Produto 7', 80, 15, false, 35.20, 4),
(8,'Produto 8', 70, 10, true, 20.00, 5);

-- Inserir dados nas tabelas fornecedores
INSERT INTO fornecedores (frn_id, frn_nome, frn_email) VALUES
(1,'Fornecedor A', 'fornecedorA@example.com'),
(2,'Fornecedor B', 'fornecedorB@example.com'),
(3,'Fornecedor C', 'fornecedorC@example.com'),
(4,'Fornecedor D', 'fornecedorD@example.com'),
(5,'Fornecedor E', 'fornecedorE@example.com'),
(6,'Fornecedor F', 'fornecedorF@example.com'),
(7,'Fornecedor G', 'fornecedorG@example.com'),
(8,'Fornecedor H', 'fornecedorH@example.com');

-- Inserir dados nas tabelas produto_fornecedor
INSERT INTO produto_fornecedor (pf_prod_id, pf_forn_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);

-- Alterar a estrutura da tabela produtos para incluir o campo de data de validade
ALTER TABLE produtos
ADD COLUMN prd_data_validade DATE;

-- Inserir novos produtos com a informação de data de validade
INSERT INTO produtos (prd_id, prd_nome, prd_qtd_estoque, prd_estoque_min, prd_perecivel, prd_valor, prd_marca_id, prd_data_validade) VALUES
(9, 'Produto 9', 60, 12, true, 18.75, 1, '2024-02-30'),
(10, 'Produto 10', 40, 8, true, 12.99, 2, '2024-08-15'),
(11, 'Produto 11', 90, 18, true, 30.50, 3, '2024-07-20');

--Criação da view para produtos e marcas
CREATE VIEW produtos_e_marcas AS
SELECT prd_id, prd_nome, prd_qtd_estoque, prd_estoque_min, prd_data_fabricacao, prd_perecivel, prd_valor, 
       mrc_nome AS marca, mrc_nacionalidade
FROM produtos
JOIN marcas ON produtos.prd_marca_id = marcas.mrc_id;


--Criação da view para produtos e fornecedores
CREATE VIEW produtos_e_fornecedores AS
SELECT prd_id, prd_nome, prd_qtd_estoque, prd_estoque_min, prd_data_fabricacao, prd_perecivel, prd_valor, 
       frn_nome AS fornecedore, frn_email
FROM produtos
JOIN fornecedores ON produtos.prd_marca_id = fornecedores.frn_id;

--Criação da view para produtos com validade venciada
CREATE VIEW produtos_validade_vencida AS
SELECT prd.prd_id, prd.prd_nome AS produto, prd.prd_data_validade, 
       mrc.mrc_nome AS marca, mrc.mrc_nacionalidade
FROM produtos prd
JOIN marcas mrc ON prd.prd_marca_id = mrc.mrc_id
WHERE prd.prd_data_validade < CURRENT_DATE;

--Criação da view para fornecedores e marcas
CREATE VIEW fornecedores_e_marcas AS
SELECT frn_nome AS fornecedore, frn_email, mrc_nome AS marca, mrc_nacionalidade
FROM fornecedores
JOIN marcas ON fornecedores.frn_id = marcas.mrc_id;

--Criação da view para produtos, fornecedores e marcas
CREATE VIEW produtos_fornecedores_marcas AS
SELECT prd.prd_id, prd.prd_nome AS produto, prd.prd_qtd_estoque, prd.prd_estoque_min, prd.prd_perecivel, prd.prd_valor,
       mrc.mrc_nome AS marca, mrc.mrc_nacionalidade,
       frn.frn_nome AS fornecedor, frn.frn_email
FROM produtos prd
JOIN produto_fornecedor pf ON prd.prd_id = pf.pf_prod_id
JOIN fornecedores frn ON pf.pf_forn_id = frn.frn_id
JOIN marcas mrc ON prd.prd_marca_id = mrc.mrc_id;

--Criação da view para produtos com estoque abaixo do minimo
CREATE VIEW produtos_estoque_baixo AS
SELECT prd_id, prd_nome, prd_qtd_estoque, prd_estoque_min
FROM produtos
WHERE prd_qtd_estoque < prd_estoque_min;

-- Cálculo da média dos preços dos produtos
SELECT AVG(prd_valor) AS media_preco FROM produtos;

-- Seleção dos produtos com preço acima da média
CREATE VIEW produtos_preco_acima_media AS
SELECT prd_id, prd_nome, prd_qtd_estoque, prd_estoque_min, prd_perecivel, prd_valor,
       prd_marca_id, prd_data_validade
FROM produtos
WHERE prd_valor > (SELECT AVG(prd_valor) FROM produtos);


--Função que mostra informações da view produtos e marcas
SELECT*FROM produtos_e_marcas;

--Função que mostra informações da view produtos e fornecedores
select*from produtos_e_fornecedores;

--Função que mostra informações da view fornecedores e marcas
SELECT*FROM fornecedores_e_marcas;

--Função que mostra informações da view produtos, fornecedores e marcas
SELECT*from produtos_fornecedores_marcas;

--Função que mostra informações da view dos produtos com baixo estoque
SELECT*from produtos_estoque_baixo;

--Função que mostra informações da view dos produtos vencidos
SELECT*from produtos_validade_vencida;

--Função que mostra os produtos com preço acima da media
SELECT*FROM produtos_preco_acima_media;
