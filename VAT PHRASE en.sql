/*
Apache License 2.0 
http://www.apache.org/licenses/

Joe Rady for 
Fleuchaus & Gallo Partnerschaft mbB
Steiner Strasse 15/A
81369 München
Germany



VAT Phrases:
select a different Text for different Invoice recipient countries. First for your own nationality (here: 'DE')
then the European Union Cuntries, then the rest of the world.

*/

select distinct

case   
when nb.state_id = 'DE' then '19% VAT'
when nb.state_id in ('BE','BG','CZ','DK','EE','IE','EL','ES','FR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','PT','RO','SI','SK','FI','SE','GB','HR') then 'Reverse Charge (§§3a, 13b UStG)'
else 'No VAT (§1(1) Nr. 1 UStG)'

end

from [dv_names_basic] nb 
where nb.name_id = 
(SELECT CASTING.ACTOR_ID
FROM dv_fin_invoice_find_cases 
INNER JOIN CASTING ON dv_fin_invoice_find_cases.case_id = CASTING.CASE_ID
WHERE     (CASTING.ROLE_TYPE_ID = 5) AND (dv_fin_invoice_find_cases.invoice_id = %IN)) and 
language_id = 3