create FUNCTION [dbo].[fCurrencyConv]
(@Orgamount money,@Currency char(3),@factor decimal)

/*converts the Input Orgamount into the Currency
utilizes the currency_validation table
and the standard foreign currency factor

select fCurrencyConv(value, Currency)
select fCurrencyConv(1000, 'USD')

*/
  RETURNS money

BEGIN

declare @Convamount money

set @Convamount = @Orgamount

set @Convamount = (@Convamount / (select top 1 currency_exch_rate from currency_validation where currency_id = @Currency
order by currency_rate_valid_date desc))

set @Convamount = (@Convamount * @factor/100)


  RETURN @Convamount
END