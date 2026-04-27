create database loja;
use loja;
create table produtos (
id int auto_increment primary key, nome varchar(100) not null,
preco decimal(10,2) not null,
fabricante varchar(100), estoque int default 0
);

insert into produtos (nome, preco, fabricante, estoque)
values ('Notebook', 3500.00, 'Dell', 10),
('Smartphone', 2000.00, 'Samsung', 25),
('Mouse', 50.00, 'Logitech', 100),
('Teclado', 120.00, 'Microsoft', 50);

create table clientes (id int auto_increment primary key, nome varchar (100) not null, email varchar (100) unique);
create table pedidos (id int auto_increment primary key, data_pedido date, cliente_id int, foreign key (cliente_id) references clientes (id) );

insert into clientes (nome, email) values ('João', 'joao@email.com'), ('Maria', 'maria@email.com');

insert into pedidos (data_pedido, cliente_id) values ('2024-01-10', 1), ('2024-01-11', 2);

SELECT clientes.nome, pedidos.data_pedido from clientes JOIN pedidos ON clientes.id = pedidos.cliente_id;
