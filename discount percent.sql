/* for advertising in the invoice how much discount the client gets
*/



SELECT
	CAST(CAST(ABS(det.DISCOUNT_PCT) AS INT) AS nvarchar)+' %' 
FROM
	pat_work_code_discount_detail det 
		JOIN pat_work_code_discount_header hed 
		ON det.DISCOUNT_ID = hed.DISCOUNT_ID 
WHERE
	hed.ACTOR_ID = %NI AND
	%RT IN (5,	20) AND
	hed.work_code_type = 'S'