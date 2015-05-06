/*
Apache License 2.0 
http://www.apache.org/licenses/

Joe Rady for 
Fleuchaus & Gallo Partnerschaft mbB
Steiner Strasse 15/A
81369 München
Germany



INvoice LC with split invoice:
If an invoice is split between several Recipients, this will only pick the percentualised portion of the individual WC

*/


DECLARE @LA INT; DECLARE @IN INT; DECLARE @CASE INT; DECLARE @OTHERS INT; DECLARE @intime VARCHAR(8); 
SET
	@LA = %LA; 
SET
	@IN = %IN; 
SELECT
	@intime = CONVERT(VARCHAR(8), invocie_date, 108) 
FROM
	invoice_header 
WHERE
	INVOICE_ID = @IN ; 
SELECT
	@CASE = CASE_ID 
FROM
	invoice_header 
WHERE
	INVOICE_ID = @IN; 
SELECT
	Top 1 @OTHERS = invoice_id 
FROM
	INVOICE_HEADER 
		JOIN BUDGET_LINE 
		ON invoice_header.INVOICE_ID = Budget_line.B_L_INVOICE_NUMBER 
WHERE
	invoice_header.CASE_ID = @case AND
	CONVERT(VARCHAR(8), invocie_date, 108) = @intime ; 
SELECT
	isnull(CAST(WORK_CODE_TEXT.WORK_CODE_TEXT AS VARCHAR(MAX)),'')+': '+( 
	CASE 
		WHEN (WORK_CODE.WORK_CODE_TYPE ='A' AND
		@LA = 3 ) 
		THEN 'Retainer Debit Note No. '+CAST(BUDGET_LINE.B_L_ADVANCE_NUMBER AS NVARCHAR(7))+' dated '+CONVERT (nvarchar(12),B_L_ADVANCE_DATE,103) 
		WHEN (WORK_CODE.WORK_CODE_TYPE ='A' AND
		@LA = 4 ) 
		THEN 'Kostenvorschussrechnung Nr. '+CAST(BUDGET_LINE.B_L_ADVANCE_NUMBER AS NVARCHAR(7))+' vom '+CONVERT (nvarchar(12),B_L_ADVANCE_DATE,104) 
		ELSE isnull(CAST(BUDGET_LINE.B_L_COMMENT AS VARCHAR(MAX)),'') 
	END )+ CHAR(9) + isnull(CAST('EUR'AS VARCHAR(11)),'') + CHAR(9) + ( 
	CASE 
		WHEN WORK_CODE.WORK_CODE_TYPE ='A' 
		THEN CHAR(45) 
		ELSE '' 
	END )+ isnull(CAST(dbo.fGetMoneyformat(((BUDGET_LINE.B_L_AMOUNT)*C.CASE_ROLE_PERCENTS/100),
	'DE') AS VARCHAR(11)),
	'') 
FROM
	TIME_REGISTRATION 
		RIGHT OUTER JOIN BUDGET_LINE 
		ON TIME_REGISTRATION.B_L_SEQ_NUMBER = BUDGET_LINE.B_L_SEQ_NUMBER AND
		TIME_REGISTRATION.B_L_CASE_ID = BUDGET_LINE.CASE_ID 
		JOIN INVOICE_HEADER ih 
		ON @IN = ih.INVOICE_ID 
		JOIN casting C 
		ON C.CASE_ID = ih.CASE_ID AND
		C.ACTOR_ID = ih.ACTOR_ID,
		WORK_CODE,
		WORK_CODE_TEXT 
WHERE
	( BUDGET_LINE.WORK_CODE_ID = WORK_CODE.WORK_CODE_ID ) AND
	( WORK_CODE.WORK_CODE_ID = WORK_CODE_TEXT.WORK_CODE_ID ) AND
	(( BUDGET_LINE.B_L_INVOICE_NUMBER = @OTHERS ) AND
	( WORK_CODE_TEXT.LANGUAGE_ID = @LA ) AND
	( WORK_CODE.WORK_CODE_TYPE IN ('S',
	'T',
	'R',
	'W',
	'A') ) AND
	( ((BUDGET_LINE.B_L_AMOUNT)*C.CASE_ROLE_PERCENTS/100) <> 0 ) AND
	( BUDGET_LINE.B_L_AMOUNT IS NOT NULL ) )