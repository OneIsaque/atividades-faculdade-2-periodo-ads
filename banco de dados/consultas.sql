SELECT clientes.nome, pedidos.data_pedido, pedidos.produto_nome
FROM clientes
JOIN pedidos ON clientes.id = pedidos.cliente_id;

SELECT clientes.nome, pedidos.data_pedido, pedidos.produto_nome
FROM clientes
LEFT JOIN pedidos ON clientes.id = pedidos.cliente_id;

SELECT clientes.nome, pedidos.data_pedido
FROM clientes
RIGHT JOIN pedidos ON clientes.id = pedidos.cliente_id;