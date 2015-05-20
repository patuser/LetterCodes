create FUNCTION [dbo].[fGetMoneyformat] (@value money,@CNotation char(2))
 /* Version for MSS 
 accepts value and CNotation
 Creates a correctly formatted number string having German or English number delimiters used in money values (e.g. 1.000,00)
 @FullEUR specifies the full EUR amount without cents
 @FullCT specifies the full CT amount
 @Notation specifies if German or English notation should be used ("1.000,00" or "1,000.00")
 USAGE:
 select fGetMoneyformat(value, "EN" or "DE")
 */
 returns varchar(25) AS
 BEGIN
    declare @ReturnStr varchar(25)
 if @Cnotation = 'DE'
 set @ReturnStr = 
 replace(  replace(  stuff(
            convert(varchar(25),convert(money,@value),1),
            charindex('.',convert(varchar(25),convert(money,@value),1))
        ,1,'#')    ,',','.'),'#',',') 
 else
 set @ReturnStr = convert(varchar(25),convert(money,@value),1) 
   return @ReturnStr
 END