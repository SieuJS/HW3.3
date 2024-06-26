CONN SYS/123@//LOCALHOST:1523/ORCLDOCKER  AS  SYSDBA; 

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE ; 
ALTER SESSION SET CURRENT_SCHEMA = QL_NHANSU ; 
CREATE OR REPLACE PROCEDURE USP_CREATEUSER AS
    CURSOR CUR IS (
        SELECT
            MANV
        FROM
            NHANVIEN
        WHERE
            MANV NOT IN (
                SELECT
                    USERNAME
                FROM
                    ALL_USERS
            )
    );
    STRSQL VARCHAR(2000);
    USR    VARCHAR2(5);
BEGIN
    OPEN CUR;
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE';
    EXECUTE IMMEDIATE(STRSQL);
    LOOP
        FETCH CUR INTO USR;
        EXIT WHEN CUR%NOTFOUND;
        STRSQL := 'CREATE USER '
                  ||USR
                  ||' IDENTIFIED BY '
                  ||USR;
        EXECUTE IMMEDIATE(STRSQL);
        STRSQL:= 'GRANT CREATE SESSION TO '
                 || USR;
        EXECUTE IMMEDIATE(STRSQL);
    END LOOP;

    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = FALSE ';
    EXECUTE IMMEDIATE(STRSQL);
    COMMIT;
    CLOSE CUR;
END;
/

CREATE OR REPLACE PROCEDURE USP_ADDUSRMEM (
    STRROLE VARCHAR,
    LOAI VARCHAR
) AS
    CURSOR CUR IS (
        SELECT
            MANV
        FROM
            NHANVIEN
        WHERE
            MANV IN (
                SELECT
                    USERNAME
                FROM
                    ALL_USERS
            )
            AND CHUCVU = LOAI
    );
    STRSQL VARCHAR(2000);
    USR    VARCHAR2(5);
BEGIN
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE';
    EXECUTE IMMEDIATE(STRSQL);
    OPEN CUR;
    LOOP
        FETCH CUR INTO USR;
        EXIT WHEN CUR%NOTFOUND;
        STRSQL:= 'GRANT '
                 ||STRROLE
                 ||' TO '
                 ||USR || ' WITH ADMIN OPTION' ;
        EXECUTE IMMEDIATE (STRSQL);
    END LOOP;

    CLOSE CUR;
END;
/

EXECUTE USP_CREATEUSER;