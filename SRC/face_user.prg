*-----------------------------------------------------------
* ��������� ������ ���������� � ������ �������� � ������
*-----------------------------------------------------------
PROCEDURE face_user

MainForm.Grid1.RecordSource = ""

Fam = ALLTRIM( ������� )
Nam	= ALLTRIM( ��� )
Ot	= ALLTRIM( �������� )

NameStreet 		= ALLTRIM( ����� )
NumHouse		= ���
NumApartament	= ��������

LOCAL ARRAY lsl[12] as Integer 	&& ������ �������� �������� ������ �� ���.
								&& ���������� ������
								
CLOSE TABLES && ������� ��� �������

IF !FILE( ALLTRIM( STR( BaseName - 1 ) ) + "\�������.dbf" )
	lsl[1] = 0.0
ELSE
	USE DataDir + ALLTRIM( STR( BaseName - 1 ) ) + "\�������.dbf"
	AbonentSeek( NameStreet, NumHouse, NumApartament )
	lsl[1] = ������
	CLOSE TABLES
ENDIF
	
FOR i = 1 TO 11
	IF FILE( ALLTRIM( STR( BaseName ) ) + "\"+ m( i ) + ".dbf" )
	USE DataDir + ALLTRIM( STR( BaseName ) )+ "\" + m( i ) + ".dbf"
	AbonentSeek( NameStreet, NumHouse, NumApartament )
	lsl[i+1] = ������
	ENDIF
ENDFOR

CLOSE TABLES


CREATE TABLE "data\faseuser.dbf" ;
(	in_saldo 	N( 12, 2 ), ;
	nach		N( 12, 2 ), ;
	k_oplate	N( 12, 2 ), ;
	korr		N( 12, 2 ), ;
	schet_441	N( 12, 2 ), ;
	schet_451	N( 12, 2 ), ;
	schet_334	N( 12, 2 ), ;
	schet_681	N( 12, 2 ), ;
	saldo		N( 12, 2 ))


* ----- ������� ������� -----
*FOR i = 1 TO 12
*	MESSAGEBOX( lsl[i] )
*ENDFOR

FOR i = 1 TO 12
	IF FILE( ALLTRIM( STR( BaseName ) ) + "\"+ m( i ) + ".dbf" )
	USE DataDir + ALLTRIM( STR( BaseName ) ) + "\" + m( i ) + ".dbf" ALIAS alias_t IN 2
	SELECT alias_t
	AbonentSeek( NameStreet, NumHouse, NumApartament )
	SELECT FASEUSER
	APPEND BLANK
	REPLACE in_saldo 	WITH lsl( i )
	REPLACE nach		WITH alias_t.���������
	REPLACE k_oplate	WITH alias_t.�_������
	REPLACE korr		WITH alias_t.���������
	REPLACE schet_441	WITH alias_t._441
	REPLACE schet_451	WITH alias_t._451
	REPLACE schet_334	WITH alias_t._334
	REPLACE schet_681	WITH alias_t.��������� + alias_t._441 + alias_t._451 + alias_t._334
	REPLACE saldo		WITH alias_t.������
	ENDIF
ENDFOR
								
CLOSE TABLES
USE DataDir+ALLTRIM( STR( BaseName ) ) + "\" + TableName + ".dbf"
REPORT FORM "fase_user" TO PRINTER PREVIEW
*===========================================
* �������������� �������� �������
*===========================================
CLOSE TABLES
USE DataDir+ALLTRIM(STR(basename))+"\"+tablename
MainForm.Grid1.RecordSource = tablename
MainForm.Grid1.Refresh()

ENDPROC