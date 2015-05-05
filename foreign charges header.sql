SELECT
	DISTINCT 
	CASE 
		WHEN EXISTS (	SELECT
							work_code_type 
						FROM
							work_code wc 
							JOIN invoice_line il 
							ON il.WORK_CODE_ID = wc.WORK_CODE_ID 
						WHERE
							il.INVOICE_ID = %IN AND
							wc.work_code_type IN ('D') AND
							%LA = 3) 
		THEN 'External services' 
		WHEN EXISTS (	SELECT
							work_code_type 
						FROM
							work_code wc 
							JOIN invoice_line il 
							ON il.WORK_CODE_ID = wc.WORK_CODE_ID 
						WHERE
							il.INVOICE_ID = %IN AND
							wc.work_code_type IN ('D') AND
							%LA = 4) 
		THEN 'Fremdleistungen' 
		ELSE '' 
	END