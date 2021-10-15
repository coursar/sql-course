CREATE TABLE customers
(
    id      bigserial PRIMARY KEY,
    name    text        NOT NULL,
    phone   text        NOT NULL UNIQUE,
    active  boolean     NOT NULL DEFAULT true,
    created timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (name, phone)
);

CREATE TABLE products
(
    id      bigserial PRIMARY KEY,
    name    text        NOT NULL,
    qty     int         NOT NULL CHECK ( qty >= 0 ) DEFAULT 0,
    price   int         NOT NULL CHECK ( price >= 0 ),
    active  boolean     NOT NULL                    DEFAULT true,
    created timestamptz NOT NULL                    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE departments
(
    id      bigserial PRIMARY KEY,
    name    text        NOT NULL,
    active  boolean     NOT NULL DEFAULT true,
    created timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE managers
(
    id            bigserial PRIMARY KEY,
    name          text        NOT NULL,
    plan          int         NOT NULL CHECK ( plan >= 0 ),
    salary        int         NOT NULL CHECK ( salary >= 0 ),
    boss_id       bigint REFERENCES managers,
    department_id bigint REFERENCES departments,
    active        boolean     NOT NULL DEFAULT true,
    created       timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales
(
    id          bigserial PRIMARY KEY,
    manager_id  bigint      NOT NULL REFERENCES managers,
    customer_id bigint REFERENCES customers,
    created     timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sale_positions
(
    id         bigserial PRIMARY KEY,
    sale_id    bigint      NOT NULL REFERENCES sales,
    product_id bigint      NOT NULL REFERENCES products,
    name       text        NOT NULL,
    qty        int         NOT NULL CHECK ( qty > 0 ),
    price      int         NOT NULL CHECK ( price >= 0 ),
    created    timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers(id, name, phone)
VALUES (1, 'Alex', '+79270009999');

INSERT INTO departments(id, name)
VALUES (1, 'front'),
       (2, 'back');

INSERT INTO managers(id, name, salary, plan, boss_id, department_id)
VALUES (1, 'Vasya', 100000, 0, NULL, NULL);

INSERT INTO managers(id, name, salary, plan, boss_id, department_id)
VALUES (2, 'Petya', 80000, 160000, 1, 1),
       (3, 'Katya', 60000, 120000, 2, 1),
       (4, 'Dasha', 90000, 180000, 1, 2),
       (5, 'Masha', 70000, 140000, 4, 2),
       (6, 'Sasha', 50000, 100000, 5, 2)
;

INSERT INTO products(id, name, qty, price)
VALUES (1, 'Big Mac', 100, 200),
       (2, 'Grig Mac', 100, 180),
       (3, 'Chicken Mac', 100, 160),
       (4, 'Coffee', 100, 150),
       (5, 'Tea', 100, 100);

INSERT INTO sales(id, manager_id, customer_id)
VALUES (1, 1, 1),    -- Vasya (id=1) 1 продажа
       (2, 2, 1),    -- Petya (id=2) 1 продажа
       (3, 3, NULL), -- Vanya (id=3) 1 продажа
       (4, 4, NULL), -- Dasha (id=4) 2 продажи
       (5, 4, NULL),
       (6, 5, NULL) -- Masha (id=5) 1 продажа
;

-- 1: Vasya (id=1) big mac'и (1) дёшево: 150, 10
-- 2: Petya (id=2) grig mac'и (2): 180, 12
-- 3: Katya (id=3) chicken mac'и (3): 160, 15
-- 4: Dasha (id=4) big mac'и (1) дорого: 250, 15
-- 4: Dasha (id=4) coffee (4) дорого: 200, 10
-- 5: Dasha (id=4) tea (5) дорого: 90, 10
-- 6: Masha (id=5) tea (5): 100, 40
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
