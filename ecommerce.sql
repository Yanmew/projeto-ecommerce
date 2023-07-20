-- Criação do banco de dados para e-commerce
CREATE SCHEMA ecommerce;
USE ecommerce;

-- Tabela cliente
CREATE TABLE clients(
	idClient INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    fname VARCHAR(10),
    minit CHAR(3),
    lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    address VARCHAR(30),
    CONSTRAINT unique_cpf_client UNIQUE(CPF)
);

-- Tabela fornecedor
CREATE TABLE  supplier(
	idSupplier INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	supplierSocialName VARCHAR(255) NOT NULL,
	CNPJ CHAR(14) NOT NULL,
	phoneNo CHAR(13) NOT NULL,  -- numero de telefone com codigo de pais e estado
	emailAddress VARCHAR(60) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- Tabela vendedor
CREATE TABLE  seller(
	idSeller INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    sellerSocialName VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    CNPJ CHAR(14),
    CPF CHAR(11),
	phoneNo CHAR(13) NOT NULL,  -- numero de telefone com codigo de pais e estado
	emailAddress VARCHAR(60) NOT NULL,
    CONSTRAINT unique_seller UNIQUE (CNPJ, CPF),
    CONSTRAINT check_cnpj_or_cpf_filled CHECK (CNPJ IS NOT NULL OR CPF IS NOT NULL) -- pelo menos um dentre CPF ou CNPJ deve estar preenchido
);
    
-- Tabela produto
CREATE TABLE products(
	idProduct INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    pname VARCHAR(30),
    is_forkids BOOL,
    category ENUM ('Electronics','Clothing','Toys','Food','Books','Tools','Games','Movies') NOT NULL,
    rating FLOAT (10,2),
    idSupplier INT,
    idSeller INT,
    size VARCHAR(10),
    CONSTRAINT product_supplier_fk FOREIGN KEY (idSupplier) REFERENCES supplier(idSupplier)
);

-- Tabela pagamento
CREATE TABLE payment(
	idPayment INT AUTO_INCREMENT NOT NULL,
    idClient INT,
    paymentMethod ENUM ('Cash','Credit Card','PayPal','Pix','Boleto Bancario') NOT NULL,
    paymentValue FLOAT,
    paymentDate DATE,
    premiumUser BOOL, -- Usuario premium paga 0 na entrega
    ccNo CHAR(16), -- numero do cartao de credito
    PRIMARY KEY (idPayment, idClient),
    CONSTRAINT payer FOREIGN KEY (idClient) REFERENCES clients(idClient) -- pessoa que realiza o pagamento
);

-- Tabela pedido
CREATE TABLE orders(
	idOrder INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    idClient INT,
    idPayment INT,
    productSeller INT,
    orderStatus ENUM('Cancelled','Awaiting Payment','Confirmed','Processing','Shipped','Arrived') DEFAULT 'Processing',
    orderDescription VARCHAR(255),
    shippingFee FLOAT DEFAULT 10,
    CONSTRAINT fl_orders_client FOREIGN KEY (idOrder) REFERENCES clients(idClient), -- pessoa que realizou o pedido
	CONSTRAINT idPayment FOREIGN KEY (idPayment) REFERENCES payment(idPayment), -- associa pedido e pagamento
    CONSTRAINT product_seller FOREIGN KEY (productSeller) REFERENCES seller(idSeller)
		ON UPDATE CASCADE
);


-- Tabela estoque
CREATE TABLE  stock(
	idProdStorage INT PRIMARY KEY,
	quantity INT NOT NULL,
	location VARCHAR(255),
	CONSTRAINT productInStorage FOREIGN KEY (idProdStorage) REFERENCES products(idProduct)
);

-- Relacionamento produto/vendedor
CREATE TABLE product_seller(
	idPseller INT,
    idPproduct INT,
    psQuantity INT default 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES products(idProduct)
);

CREATE TABLE product_order(
	idPOproduct INT,
    idPOorder INT,
    idOrderClient INT,
    poQuantity INT default 1,
    poStatus ENUM ('Available','Out of Stock') default 'Out of Stock',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_PO_product_seller FOREIGN KEY (idPOproduct) REFERENCES products(idProduct),
    CONSTRAINT fk_PO_product_product FOREIGN KEY (idPOorder) REFERENCES orders(idOrder),
	CONSTRAINT idOrderClient FOREIGN KEY (idOrderClient) REFERENCES orders(idOrder)
);

CREATE TABLE storageLocation(
	idLproduct INT,
    idLstorage INT,
    location VARCHAR (255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_SL_product_seller FOREIGN KEY (idLproduct) REFERENCES products(idProduct),
    CONSTRAINT fk_SL_product_product FOREIGN KEY (idLstorage) REFERENCES orders(productSeller)
);

show tables;
show databases;

-- DROP DATABASE ecommerce; -- deletar tudo caso precise ajustar algo

-- INSERTS --

INSERT INTO clients (fname, minit, lname, CPF, address)
VALUES
    ('John', 'D', 'Doe', '12345678901', '123 Main St'),
    ('Jane', 'A', 'Smith', '98765432109', '456 Oak Ave'),
    ('Michael', 'B', 'Johnson', '45678901234', '789 Elm Rd');
    
INSERT INTO supplier (supplierSocialName, CNPJ, phoneNo, emailAddress)
VALUES
    ('ABC Electronics', '12345678901234', '11234567890', 'info@abc-electronics.com'),
    ('XYZ Clothing', '98765432109876', '29876543210', 'contact@xyz-clothing.com'),
    ('Best Toys', '45678901234567', '34567890123', 'sales@best-toys.com');

INSERT INTO seller (sellerSocialName, location, CNPJ, CPF, phoneNo, emailAddress)
VALUES
    ('Tech Gadgets', 'Los Angeles', '12345678901234', NULL, '12345678901', 'techgadgets@example.com'),
    ('Fashion Trends', 'New York', '98765432109876', NULL, '23456789012', 'fashiontrends@example.com'),
    ('Books Emporium', 'Chicago', NULL, '34567890123', '34567890123', 'booksemp@example.com');

INSERT INTO products (pname, is_forkids, category, rating, idSupplier, idSeller, size)
VALUES
    ('Smartphone', 0, 'Electronics', 4.5, 1, 1, '5.5-inch'),
    ('T-shirt', 1, 'Clothing', 4.2, 2, 2, 'M'),
    ('Remote Control Car', 1, 'Toys', 4.8, 3, 3, 'Large');

INSERT INTO payment (idClient, paymentMethod, paymentValue, paymentDate, premiumUser, ccNo)
VALUES
    (1, 'Credit Card', 500.00, '2023-07-20', 0, '************1234'),
    (2, 'PayPal', 29.99, '2023-07-19', 1, NULL),
    (3, 'Boleto Bancario', 150.00, '2023-07-18', 0, NULL);

INSERT INTO orders (idClient, idPayment, productSeller, orderStatus, orderDescription, shippingFee)
VALUES
    (1, 1, 1, 'Processing', 'Order #12345', 10.00),
    (2, 2, 2, 'Confirmed', 'Order #54321', 12.50),
    (3, 3, 3, 'Shipped', 'Order #98765', 8.75);

INSERT INTO stock (idProdStorage, quantity, location)
VALUES
    (1, 100, 'Warehouse A'),
    (2, 50, 'Warehouse B'),
    (3, 75, 'Warehouse C');

INSERT INTO product_seller (idPseller, idPproduct, psQuantity)
VALUES
    (1, 1, 50),
    (2, 2, 25),
    (3, 3, 35);

INSERT INTO product_order (idPOproduct, idPOorder, idOrderClient, poQuantity, poStatus)
VALUES
    (1, 1, 1, 1, 'Available'),
    (2, 2, 2, 1, 'Out of Stock'),
    (3, 3, 3, 2, 'Available');

INSERT INTO storageLocation (idLproduct, idLstorage, location)
VALUES
    (1, 1, 'Warehouse A - Section 1'),
    (2, 2, 'Warehouse B - Section 2'),
    (3, 3, 'Warehouse C - Section 3');


-- QUERIES --

-- Selectionar todos os clientes
SELECT * FROM clients;

-- Selecionar eletronicos
SELECT * FROM products WHERE category = 'Electronics'; 

-- Selecionar vendedores e quantidade de produtos a venda
SELECT seller.idSeller, seller.sellerSocialName, COUNT(products.idProduct) AS total_products
FROM seller
LEFT JOIN products ON seller.idSeller = products.idSeller
GROUP BY seller.idSeller, seller.sellerSocialName;

-- Seleciona a avaliacao media dos produtos em cada categoria
SELECT category, AVG (rating) AS average_rating
FROM products
GROUP BY category;

-- Valor total de pagamentos para cada meio de pagamento
SELECT paymentMethod, SUM(paymentValue) AS total_payment_value
FROM payment
GROUP BY paymentMethod;

-- Seleciona clientes, seus pedidos, meio de pagamento e valor pago
SELECT orders.idOrder, clients.fname, clients.lname, payment.paymentMethod, payment.paymentValue
FROM orders
INNER JOIN clients ON orders.idClient = clients.idClient
INNER JOIN payment ON orders.idPayment = payment.idPayment;

-- Seleciona produto, fornecedor e email do fornecedor
SELECT products.pname, supplier.supplierSocialName, supplier.emailAddress
FROM products
INNER JOIN supplier ON products.idSupplier = supplier.idSupplier;

-- Seleciona produtos fora de estoque
SELECT idPOproduct, idPOorder
FROM product_order
WHERE poStatus = 'Out of Stock';

-- Categoriza produtos baseado na avaliacao de cada um
SELECT
    pname,
    rating,
    CASE
        WHEN rating >= 4.5 THEN 'Excellent'
        WHEN rating >= 4.0 THEN 'Very Good'
        WHEN rating >= 3.5 THEN 'Good'
        ELSE 'Average or Below'
    END AS rating_category
FROM products
ORDER BY rating DESC;

-- Seleciona produtos com nota maior ou igual a nota estipulada
SELECT
    pname,
    AVG(rating) AS average_rating
FROM products
GROUP BY pname
HAVING AVG(rating) > 4.7;