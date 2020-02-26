CREATE TABLE TRADER(
    TRADER_ID NUMBER PRIMARY KEY NOT NULL,
    TRADER_TYPE VARCHAR2(25) NOT NULL,
    TRADER_NAME VARCHAR2(30) NOT NULL,
    OWNER_NAME VARCHAR2(30) NOT NULL,
    STATUS VARCHAR2(15)
)

CREATE TABLE FARMER(
    FARMER_ID NUMBER PRIMARY KEY NOT NULL,
    FARMER_TYPE VARCHAR2(25) NOT NULL,
    FARMER_NAME VARCHAR2(30) NOT NULL,
    STATUS VARCHAR2(15) 
)

CREATE TABLE BATCH(
    BATCH_ID NUMBER PRIMARY KEY NOT NULL,
    START_BALANCE DECIMAL(15,2) DEFAULT 0,
    TRADER_ID NUMBER NOT NULL,
    OPENING_DATE DATE NOT NULL,
    CONSTRAINT FK_TRADER_BATCH FOREIGN KEY(TRADER_ID) REFERENCES TRADER(TRADER_ID)
)

CREATE TABLE INVENTORY_BOOK(
    PRODUCT_ID NUMBER PRIMARY KEY NOT NULL,
    PRODUCT_NAME VARCHAR2(25) NOT NULL,
    QUANTITY_TYPE VARCHAR2(10) NOT NULL,
    PRICE DECIMAL(15,2) NOT NULL,
    QUANTITY NUMBER NOT NULL,
    INV_BOOK_DATE DATE NOT NULL,
    TRADER_ID NUMBER NOT NULL,
    CONSTRAINT FK_TRADER_INV_BOOK FOREIGN KEY(TRADER_ID) REFERENCES TRADER(TRADER_ID)
)
    
CREATE TABLE REGISTER_SELL (
        REG_SELL_ID NUMBER PRIMARY KEY NOT NULL,
        PRODUCT_ID NUMBER NOT NULL,
        QUANTITY NUMBER NOT NULL,
        CONSTRAINT FK_REGISTER_INV_BOOK FOREIGN KEY(PRODUCT_ID) REFERENCES INVENTORY_BOOK(PRODUCT_ID)
)

CREATE TABLE SUSPICIOUS_PAST(
    SUSPICIOUS_ID NUMBER PRIMARY KEY NOT NULL,
    SUSPICIOUS_NAME VARCHAR2(30) NOT NULL,
    SUSPICIOUS_TYPE VARCHAR2(25) NOT NULL
)

CREATE TABLE BAD_TRADER(
    BAD_TRADER_ID NUMBER PRIMARY KEY NOT NULL,
    BAD_TRADER_NAME VARCHAR2(30) NOT NULL,
    BAD_TRADER_TYPE VARCHAR2(25) NOT NULL
)

CREATE TABLE MISTAKES(
    MISTAKES_ID NUMBER PRIMARY KEY NOT NULL,
    TRADER_ID NUMBER NOT NULL,
    TRADER_NAME VARCHAR2(30) NOT NULL
)

CREATE TABLE UNSUCCESSFUL_SEL(
        SELL_ID NUMBER PRIMARY KEY NOT NULL,
        PRODUCT_ID NUMBER NOT NULL,
        QUANTITY NUMBER NOT NULL,
        CONSTRAINT FK_REGISTER_IN_BOOK FOREIGN KEY(PRODUCT_ID) REFERENCES INVENTORY_BOOK(PRODUCT_ID)
)

CREATE TABLE DAILY_SUM_REPORT(
    REPORT_ID NUMBER PRIMARY KEY NOT NULL,
    REP_SUM DECIMAL(15,2),
    OBLIGATION DECIMAL(15,2),
    TRADER_ID NUMBER NOT NULL,
    CONSTRAINT FK_TRADER_SUM FOREIGN KEY(TRADER_ID) REFERENCES TRADER(TRADER_ID)
)

CREATE TABLE TAX_FREE(
    TAX_FREE_ID NUMBER PRIMARY KEY NOT NULL,
    TRADER_ID NUMBER,
    CONSTRAINT FK_TRADER_TAX_FREE FOREIGN KEY(TRADER_ID) REFERENCES TRADER(TRADER_ID)
)

CREATE TABLE MONTH_REPORT(
    REPORT_ID NUMBER NOT NULL PRIMARY KEY,
    REP_SUM DECIMAL(15,2),
    OBLIGAITON DECIMAL(15,2),
    TRADER_ID NUMBER NOT NULL,
    MONT DATE,
    CONSTRAINT FK_MONTH_REPORT FOREIGN KEY(TRADER_ID) REFERENCES TRADER(TRADER_ID)
)

INSERT INTO TRADER(TRADER_ID,TRADER_TYPE,TRADER_NAME,OWNER_NAME)
VALUES(1,'fizichesko lice','Boris','Boris');

INSERT INTO TRADER(TRADER_ID,TRADER_TYPE,TRADER_NAME,OWNER_NAME)
VALUES(2,'uridichesko lice','Petyr','Ivan');

INSERT INTO TRADER(TRADER_ID,TRADER_TYPE,TRADER_NAME,OWNER_NAME)
VALUES(3,'uridichesko lice','Tania','Pesho');

INSERT INTO FARMER(FARMER_ID,FARMER_TYPE,FARMER_NAME)
VALUES(4,'fizichesko lice','Kosara');

INSERT INTO SUSPICIOUS_PAST(SUSPICIOUS_ID,SUSPICIOUS_NAME,SUSPICIOUS_TYPE)
VALUES(5,'Bilyana','uridichesko lice');

INSERT INTO TAX_FREE(TAX_FREE_ID,TRADER_ID)
VALUES(1,2);

/*?????? ?????? ???? 1*/
/*????????? ????,????????????? ? ??????? farmer => status = ?????????*/
DECLARE
    l_trader_id NUMBER := 4;
    l_trader_name VARCHAR2(30) := 'Kosara';
    l_owner_name VARCHAR2(30) := 'Kosara';
    l_trader_type VARCHAR2(30) := 'fizichesko lice';
    l_trader_status VARCHAR2(15);
    l_count number := 0;

BEGIN
    SELECT COUNT(1) INTO l_count FROM FARMER
    WHERE FARMER_ID = l_trader_id;
    
    IF l_count > 0
    THEN l_trader_status := 'zemedelec';
        INSERT INTO TRADER(TRADER_ID,TRADER_TYPE,TRADER_NAME,OWNER_NAME,STATUS)
        VALUES(l_trader_id,l_trader_name,l_owner_name,l_trader_type,l_trader_status);
    ELSE 
        INSERT INTO TRADER(TRADER_ID,TRADER_TYPE,TRADER_NAME,OWNER_NAME)
        VALUES(l_trader_id,l_trader_name,l_owner_name,l_trader_type);
    END IF;
END;

SELECT * FROM TRADER;

/*?????????? ???? ?? ????????? ?? ???????? ??? ?????????? ?????? => ????? ? ????????? ?? ??????????? ????????.*/
DECLARE 
    l_trader_id NUMBER := 5;
    l_trader_name VARCHAR2(30) := 'Bilyana';
    l_owner_name VARCHAR2(30) := 'Vasil';
    l_trader_type VARCHAR2(30) := 'uridichesko lice';
    l_count number := 0;
BEGIN
    SELECT COUNT(1) INTO l_count FROM SUSPICIOUS_PAST
    WHERE SUSPICIOUS_ID = l_trader_id;
    
    IF l_count > 0 THEN
        INSERT INTO BAD_TRADER(BAD_TRADER_ID,BAD_TRADER_NAME,BAD_TRADER_TYPE)
        VALUES(l_trader_id,l_trader_name,l_trader_type);
    ELSE
        INSERT INTO TRADER(TRADER_ID,TRADER_TYPE,TRADER_NAME,OWNER_NAME)
        VALUES(l_trader_id,l_trader_name,l_owner_name,l_trader_type);
    END IF;
END;

SELECT * FROM SUSPICIOUS_PAST;

SELECT * FROM BAD_TRADER;

/*????????? ?? ??????????? ???????????? ?? ????????? ? ?????????? ????.*/
DECLARE
    l_trader_id NUMBER := 4;
    l_trader_name VARCHAR2(30) := 'Kosara';
    l_owner_name VARCHAR2(30) := 'Kosara';
    l_trader_type VARCHAR2(30) := 'uridichesko lice';
    l_trader_status VARCHAR2(15);
    l_mistake_id NUMBER := 1;
    l_count number := 0;
BEGIN
    SELECT COUNT(1) into l_count FROM TRADER
    WHERE TRADER_ID = l_trader_id;
    
    IF l_count > 0 THEN
        INSERT INTO MISTAKES(MISTAKES_ID,TRADER_ID,TRADER_NAME)
        VALUES(l_mistake_id,l_trader_id,l_trader_name);
    ELSE 
        INSERT INTO TRADER(TRADER_ID,TRADER_TYPE,TRADER_NAME,OWNER_NAME)
        VALUES(l_trader_id,l_trader_name,l_owner_name,l_trader_type);
    END IF;
END;

SELECT * FROM MISTAKES;

/*???????? ?? ??????? ?? ????? ????????.*/
DECLARE
    l_batch_id NUMBER;
    l_start_balance DECIMAL := 0;
    l_trader_id NUMBER;
    l_opening_date DATE := sysdate;
BEGIN 
    FOR I IN (SELECT TRADER_ID FROM TRADER) LOOP
        l_trader_id := I.TRADER_ID;
        l_batch_id := l_trader_id;
        
        INSERT INTO BATCH(BATCH_ID,START_BALANCE,TRADER_ID,OPENING_DATE)
        VALUES(l_batch_id,l_start_balance,l_trader_id,l_opening_date);
    END LOOP;
END;

SELECT * FROM BATCH;

/*?????? ?????? ???? 2.*/
SELECT * FROM TRADER;

INSERT INTO INVENTORY_BOOK(PRODUCT_ID,PRODUCT_NAME,QUANTITY_TYPE,PRICE,QUANTITY,INV_BOOK_DATE,TRADER_ID)
VALUES(1,'Potato','kg',2.30,20,sysdate,1);

INSERT INTO INVENTORY_BOOK(PRODUCT_ID,PRODUCT_NAME,QUANTITY_TYPE,PRICE,QUANTITY,INV_BOOK_DATE,TRADER_ID)
VALUES(2,'Avocado','br',2.99,30,sysdate,2);

INSERT INTO INVENTORY_BOOK(PRODUCT_ID,PRODUCT_NAME,QUANTITY_TYPE,PRICE,QUANTITY,INV_BOOK_DATE,TRADER_ID)
VALUES(3,'Carrot','kg',2.30,40,sysdate,3);

INSERT INTO INVENTORY_BOOK(PRODUCT_ID,PRODUCT_NAME,QUANTITY_TYPE,PRICE,QUANTITY,INV_BOOK_DATE,TRADER_ID)
VALUES(4,'Tomato','kg',1.79,48,sysdate,4);

SELECT * FROM INVENTORY_BOOK;

/*????????*/

DECLARE
    l_product_id NUMBER := 2;
    l_price DECIMAL(15,2);
    l_quantity NUMBER;
    l_trader_id NUMBER := 2;
    l_reg_sell_id NUMBER := 1;
    l_selling_quantity NUMBER := 3;
    
BEGIN
    SELECT QUANTITY INTO l_quantity FROM INVENTORY_BOOK
    WHERE l_product_id = INVENTORY_BOOK.PRODUCT_ID AND l_trader_id = INVENTORY_BOOK.TRADER_ID;
    
    IF l_selling_quantity < l_quantity THEN
        UPDATE INVENTORY_BOOK
        SET QUANTITY = QUANTITY - l_selling_quantity;
        
        INSERT INTO REGISTER_SELL(REG_SELL_ID,PRODUCT_ID,QUANTITY)
        VALUES(l_reg_sell_id,l_product_id,l_selling_quantity);
    ELSE
        INSERT INTO UNSUCCESSFUL_SEL(SELL_ID,PRODUCT_ID,QUANTITY)
        VALUES(l_reg_sell_id,l_product_id,l_selling_quantity);
    END IF;
END;

/*?????? ?????? ???? 3.*/

DECLARE
    l_sum NUMBER;
    l_product_id NUMBER := 1;
    l_trader_id NUMBER := 1;
    l_report_id NUMBER := 1;
    l_tax NUMBER;
    l_trader_type VARCHAR2(20);
    l_count NUMBER := 0;
    
    
BEGIN
    SELECT SUM(QUANTITY*PRICE) INTO l_sum FROM INVENTORY_BOOK
    WHERE PRODUCT_ID = l_product_id AND TRADER_ID = l_trader_id;
    
    SELECT COUNT(TRADER_ID) INTO l_count FROM TAX_FREE
    WHERE TRADER_ID = l_trader_id;
    
    SELECT TRADER_TYPE into l_trader_type FROM TRADER 
    WHERE TRADER_ID = l_trader_id;
    
    IF l_sum BETWEEN 1 AND 5000 THEN
                 INSERT INTO DAILY_SUM_REPORT
                 VALUES(l_report_id,0,0,l_trader_id);
    
    ELSIF l_sum BETWEEN 5000 AND 7500 THEN
        IF l_count > 0 THEN
            l_tax := 0;
            INSERT INTO DAILY_SUM_REPORT
            VALUES(l_report_id,l_sum,l_tax,l_trader_id);
        ELSE
            IF l_trader_type = 'fizichesko lice' THEN
                l_sum := l_sum - 2500;
                l_tax := 0.05*l_sum;
                l_sum := l_sum - l_tax;
        
                INSERT INTO DAILY_SUM_REPORT
                VALUES(l_report_id,l_sum,l_tax,l_trader_id);
            ELSE
                l_tax := 0.05*l_sum;
                l_sum := l_sum - l_tax;
        
                INSERT INTO DAILY_SUM_REPORT
                VALUES(l_report_id,l_sum,l_tax,l_trader_id);
            END IF;
        END IF;
        
    ELSIF l_sum BETWEEN 7500 AND 10000 THEN
        IF l_count > 0 THEN
            l_tax := 0;
            INSERT INTO DAILY_SUM_REPORT
            VALUES(l_report_id,l_sum,l_tax,l_trader_id);
        ELSE
            IF l_trader_type = 'fizichesko lice' THEN
                l_sum := l_sum - 2500;
                l_tax := 0.07*l_sum;
                l_sum := l_sum - l_tax;
        
                INSERT INTO DAILY_SUM_REPORT
                VALUES(l_report_id,l_sum,l_tax,l_trader_id);
            ELSE
                l_tax := 0.07*l_sum;
                l_sum := l_sum - l_tax;
        
                INSERT INTO DAILY_SUM_REPORT
                VALUES(l_report_id,l_sum,l_tax,l_trader_id);
            END IF;
        END IF;
    ELSE 
        IF l_count > 0 THEN
            l_tax := 0;
            INSERT INTO DAILY_SUM_REPORT
            VALUES(l_report_id,l_sum,l_tax,l_trader_id);
        ELSIF l_trader_type = 'fizichesko lice' THEN
                l_sum := l_sum - 2500;
                l_tax := 0.1*l_sum;
                l_sum := l_sum - l_tax;
        
                INSERT INTO DAILY_SUM_REPORT
                VALUES(l_report_id,l_sum,l_tax,l_trader_id);
        ELSE
                l_tax := 0.1*l_sum;
                l_sum := l_sum - l_tax;
        
                INSERT INTO DAILY_SUM_REPORT
                VALUES(l_report_id,l_sum,l_tax,l_trader_id);
        END IF;
    END IF;
END;

select * from DAILY_SUM_REPORT;

/*?????? ?????? ???? 4*/

DECLARE
    l_month_repo_id NUMBER;
    l_month DATE;
    l_rep_sum DECIMAL(15,2);
    l_tax DECIMAL(15,2);
    l_trader_id NUMBER;
    l_count NUMBER := 0;
BEGIN
    SELECT COUNT(REPORT_ID) INTO l_count FROM DAILY_SUM_REPORT;
    SELECT SUM(REP_SUM) INTO l_rep_sum FROM DAILY_SUM_REPORT WHERE TRADER_ID = l_trader_id;
    
    IF l_month between to_date('01/02/2020','dd/mm/yyyy') and to_date('29/02/2020','dd/mm/yyyy') THEN
    INSERT INTO MONTH_REPORT
    VALUES(l_month_repo_id,l_rep_sum,l_tax,l_trader_id,l_month);
    END IF;
END;




















