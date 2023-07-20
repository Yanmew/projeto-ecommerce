
# Projeto de e-commerce para o bootcamp Potência Tech powered by iFood | Ciências de Dados com Python

Este é um resumo do script SQL para criação de um banco de dados de e-commerce. O banco de dados contém tabelas para armazenar informações sobre clientes, fornecedores, vendedores, produtos, pagamentos, pedidos e estoque.

## Tabelas

### Tabela "clients"

Armazena informações dos clientes do e-commerce, incluindo nome, sobrenome, CPF, e endereço.

### Tabela "supplier"

Registra os fornecedores do e-commerce, com detalhes como nome social, CNPJ, telefone e endereço de e-mail.

### Tabela "seller"

Contém informações dos vendedores do e-commerce, incluindo nome social, CNPJ, CPF (opcional), telefone e endereço de e-mail.

### Tabela "products"

Armazena os produtos disponíveis no e-commerce, como nome, categoria, avaliação, tamanho e informações sobre o fornecedor e vendedor associados.

### Tabela "payment"

Registra os pagamentos realizados pelos clientes, com detalhes como método de pagamento, valor, data e informações sobre o cliente.

### Tabela "orders"

Contém os pedidos feitos pelos clientes, com informações como status, descrição do pedido, taxa de envio e detalhes sobre o cliente e pagamento associado.

### Tabela "stock"

Armazena o estoque disponível para cada produto, incluindo a quantidade e a localização.

### Tabela "product_seller"

Estabelece o relacionamento entre produtos e vendedores, registrando a quantidade de produtos que cada vendedor possui.

### Tabela "product_order"

Registra os produtos associados a cada pedido, com informações sobre a quantidade e o status do produto no pedido.

### Tabela "storageLocation"

Armazena informações sobre a localização do estoque de cada produto.

## Dados Inseridos (INSERTS)

O script inclui inserção de dados de exemplo nas tabelas de clientes, fornecedores, vendedores, produtos, pagamentos, pedidos e estoque. Esses dados simulam informações reais do e-commerce.

## Exemplos de Consultas (QUERIES)

O script também inclui exemplos de consultas que podem ser realizadas no banco de dados para obter informações relevantes sobre clientes, produtos, pagamentos e pedidos.

