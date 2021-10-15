CREATE TABLE customers
(
    id      bigint PRIMARY KEY IDENTITY (1,1),
    name    nvarchar(300)  NOT NULL,
    phone   nvarchar(20)   NOT NULL UNIQUE,
    active  BIT            NOT NULL DEFAULT 1,
    created datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (name, phone)
);

CREATE TABLE products
(
    id      bigint PRIMARY KEY IDENTITY (1,1),
    name    nvarchar(300)  NOT NULL,
    qty     int            NOT NULL CHECK ( qty >= 0 ) DEFAULT 0,
    price   int            NOT NULL CHECK ( price >= 0 ),
    active  BIT            NOT NULL                    DEFAULT 1,
    created datetimeoffset NOT NULL                    DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE departments
(
    id      bigint PRIMARY KEY IDENTITY (1,1),
    name    nvarchar(300)  NOT NULL,
    active  BIT            NOT NULL DEFAULT 1,
    created datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE managers
(
    id            bigint PRIMARY KEY IDENTITY (1,1),
    name          nvarchar(300)  NOT NULL,
    [plan]        int            NOT NULL CHECK ( [plan] >= 0 ),
    salary        int            NOT NULL CHECK ( salary >= 0 ),
    boss_id       bigint REFERENCES managers,
    department_id bigint REFERENCES departments,
    active        BIT            NOT NULL DEFAULT 1,
    created       datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE sales
(
    id          bigint PRIMARY KEY IDENTITY (1,1),
    manager_id  bigint         NOT NULL REFERENCES managers,
    customer_id bigint         REFERENCES customers,
    created     datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE sale_positions
(
    id         bigint PRIMARY KEY IDENTITY (1,1),
    sale_id    bigint         NOT NULL REFERENCES sales,
    product_id bigint         NOT NULL REFERENCES products,
    name       nvarchar(300)  NOT NULL,
    qty        int            NOT NULL CHECK ( qty > 0 ),
    price      int            NOT NULL CHECK ( price >= 0 ),
    created    datetimeoffset NOT NULL DEFAULT CURRENT_TIMESTAMP,
);

SET IDENTITY_INSERT customers ON;
INSERT INTO customers(id, name, phone)
VALUES (1, 'Alex', '+79270009999');
SET IDENTITY_INSERT customers OFF;

SET IDENTITY_INSERT departments ON;
INSERT INTO departments(id, name)
VALUES (1, 'front'),
       (2, 'back');
SET IDENTITY_INSERT departments OFF;

SET IDENTITY_INSERT managers ON;
INSERT INTO managers(id, name, salary, [plan], boss_id, department_id)
VALUES (1, 'Vasya', 100000, 0, NULL, NULL);
SET IDENTITY_INSERT managers OFF;

SET IDENTITY_INSERT managers ON;
INSERT INTO managers(id, name, salary, [plan], boss_id, department_id)
VALUES (2, 'Petya', 80000, 160000, 1, 1),
       (3, 'Katya', 60000, 120000, 2, 1),
       (4, 'Dasha', 90000, 180000, 1, 2),
       (5, 'Masha', 70000, 140000, 4, 2),
       (6, 'Sasha', 50000, 100000, 5, 2)
;
SET IDENTITY_INSERT managers OFF;

SET IDENTITY_INSERT products ON;
INSERT INTO products(id, name, qty, price)
VALUES (1, 'Big Mac', 100, 200),
       (2, 'Grig Mac', 100, 180),
       (3, 'Chicken Mac', 100, 160),
       (4, 'Coffee', 100, 150),
       (5, 'Tea', 100, 100);
SET IDENTITY_INSERT products OFF;

SET IDENTITY_INSERT sales ON
INSERT INTO sales(id, manager_id, customer_id)
VALUES (1, 1, 1),    -- Vasya (id=1) 1 продажа
       (2, 2, 1),    -- Petya (id=2) 1 продажа
       (3, 3, NULL), -- Vanya (id=3) 1 продажа
       (4, 4, NULL), -- Dasha (id=4) 2 продажи
       (5, 4, NULL),
       (6, 5, NULL)
SET IDENTITY_INSERT sales OFF -- Masha (id=5) 1 продажа
;

-- 1: Vasya (id=1) big mac'и (1) дёшево: 150, 10
-- 2: Petya (id=2) grig mac'и (2): 180, 12
-- 3: Katya (id=3) chicken mac'и (3): 160, 15
-- 4: Dasha (id=4) big mac'и (1) дорого: 250, 15
-- 4: Dasha (id=4) coffee (4) дорого: 200, 10
-- 5: Dasha (id=4) tea (5) дорого: 90, 10
-- 6: Masha (id=5) tea (5): 100, 40
SET IDENTITY_INSERT sale_positions ON;
INSERT INTO sale_positions(id, sale_id, product_id, name, qty, price)
VALUES (1, 1, 1, 'Big Mac', 10, 150),
       (2, 2, 2, 'Grig Mac', 12, 180),
       (3, 3, 3, 'Chicken Mac', 15, 160),
-- Dasha (продала big mac + coffee)
       (4, 4, 1, 'Big Mac', 15, 250),
       (5, 4, 4, 'Coffee', 10, 200),
-- Dasha (продала tea)
       (6, 5, 5, 'Tea', 10, 90),
-- Masha
       (7, 6, 5, 'Tea', 40, 100);
SET IDENTITY_INSERT sale_positions OFF;
