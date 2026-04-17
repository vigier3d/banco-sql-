-- ============================================
-- CRIAÇÃO DO BANCO DE DADOS
-- ============================================

CREATE DATABASE loja; -- Cria o banco de dados chamado 'loja'

USE loja; -- Seleciona o banco para uso


-- ============================================
-- TABELA CLIENTE
-- ============================================

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único do cliente (PK)
    nome VARCHAR(100) NOT NULL, -- Nome do cliente (obrigatório)
    email VARCHAR(100) UNIQUE NOT NULL, -- Email único (não pode repetir)
    telefone VARCHAR(20) -- Telefone (opcional)
);


-- ============================================
-- TABELA PRODUTO
-- ============================================

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único do produto (PK)
    nome VARCHAR(100) NOT NULL, -- Nome do produto
    preco DECIMAL(10,2) NOT NULL, -- Preço com 2 casas decimais
    estoque INT DEFAULT 0 -- Quantidade disponível em estoque
);


-- ============================================
-- TABELA PEDIDO
-- ============================================

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY, -- ID único do pedido (não depende de outras tabelas)
    id_cliente INT NOT NULL, -- Chave estrangeira para cliente
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP, -- Data automática do pedido

    -- RELACIONAMENTO COM CLIENTE
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);


-- ============================================
-- TABELA ITENS_PEDIDO (CHAVE COMPOSTA)
-- ============================================

CREATE TABLE itens_pedido (
    id_pedido INT NOT NULL, -- Referência ao pedido
    id_produto INT NOT NULL, -- Referência ao produto

    quantidade INT NOT NULL, -- Quantidade do produto no pedido
    preco_unitario DECIMAL(10,2) NOT NULL, -- Preço no momento da compra

    -- CHAVE PRIMÁRIA COMPOSTA
    PRIMARY KEY (id_pedido, id_produto), -- Garante que um produto não se repita no mesmo pedido

    -- CHAVES ESTRANGEIRAS
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);


-- ============================================
-- INSERINDO DADOS DE TESTE
-- ============================================

-- Inserindo clientes
INSERT INTO cliente (nome, email, telefone) VALUES
('João Silva', 'joao@email.com', '21999999999'),
('Maria Souza', 'maria@email.com', '21888888888');

-- Inserindo produtos
INSERT INTO produto (nome, preco, estoque) VALUES
('Notebook', 3500.00, 10),
('Mouse', 50.00, 100),
('Teclado', 120.00, 50);

-- Criando pedido para o cliente 1
INSERT INTO pedido (id_cliente) VALUES (1);

-- Inserindo itens no pedido (chave composta evita duplicação)
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00), -- Notebook
(1, 2, 2, 50.00);   -- 2 Mouses


-- ============================================
-- CONSULTA COMPLETA COM JOIN
-- ============================================

SELECT 
    c.nome AS cliente, -- Nome do cliente
    p.id_pedido, -- ID do pedido
    p.data_pedido, -- Data do pedido
    pr.nome AS produto, -- Nome do produto
    i.quantidade, -- Quantidade comprada
    i.preco_unitario, -- Preço unitário
    (i.quantidade * i.preco_unitario) AS total_item -- Total por item

FROM pedido p

-- JUNÇÕES ENTRE TABELAS
JOIN cliente c ON p.id_cliente = c.id_cliente -- Liga pedido ao cliente
JOIN itens_pedido i ON p.id_pedido = i.id_pedido -- Liga pedido aos itens
JOIN produto pr ON i.id_produto = pr.id_produto; -- Liga item ao produto