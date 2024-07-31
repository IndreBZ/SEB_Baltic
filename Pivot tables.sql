-- transform table row <->columns
USE maint
--[IBZ_HICP_annual_data_average_index_and_rate_of_change]
SELECT  [freq]
      ,[nit]
      ,[coicop]
      ,[geo]
      ,[Period],[Amount]
  INTO #HICP_annual_data_average_index_and_rate_of_change
  FROM [maint].[dbo].[IBZ_HICP_annual_data_average_index_and_rate_of_change]
  UNPIVOT
	(
	[Amount] FOR [Period] IN ([2010]
      ,[2011]
      ,[2012]
      ,[2013]
      ,[2014]
      ,[2015]
      ,[2016]
      ,[2017]
      ,[2018]
      ,[2019]
      ,[2020]
      ,[2021]
      ,[2022]
      ,[2023])
	) AS UPT 
WHERE coicop = 'CP00'

SELECT freq,coicop,geo, Period,[INX_A_AVG],[RCH_A_AVG]
INTO dbo.IBZ_HICP_annual_data_average_index_and_rate_of_change_PIVOT
FROM
  (SELECT freq,coicop,geo,nit,[Amount], Period FROM #HICP_annual_data_average_index_and_rate_of_change) AS IQ
  PIVOT
  (
  SUM([Amount]) 
  FOR nit 
    IN([INX_A_AVG],[RCH_A_AVG]
    )
  ) AS PT
  
  --[IBZ_Convergence_indicators]
  SELECT freq,
         statinfo,
         unit,
         geo,
         Period,
         Amount 
  INTO #IBZ_Convergence_indicators
  FROM [dbo].[IBZ_Convergence_indicators] 
  UNPIVOT
	(
	[Amount] FOR [Period] IN ([2010]
      ,[2011]
      ,[2012]
      ,[2013]
      ,[2014]
      ,[2015]
      ,[2016]
      ,[2017]
      ,[2018]
      ,[2019]
      ,[2020]
      ,[2021]
      ,[2022]
      ,[2023])
	) AS UPT 
	WHERE ppp_cat = 'GDP'

SELECT freq,geo, Period,CV_PLI,CV_VI_HAB
INTO dbo.[IBZ_Convergence_indicators_PIVOT]
FROM
  (SELECT freq,geo,statinfo,[Amount], Period FROM #IBZ_Convergence_indicators) AS IQ
  PIVOT
  (
  SUM([Amount]) 
  FOR statinfo 
    IN(CV_PLI,CV_VI_HAB )
  ) AS PT

--[dbo].[IBZ_House_price_index]
SELECT * 
--INTO [#IBZ_House_price_index]
FROM [dbo].[IBZ_House_price_index] 
UNPIVOT
	(
	[Amount] FOR [Period] IN (
[2010.Q1],[2010.Q2],[2010.Q3],[2010.Q4],[2011.Q1],[2011.Q2],[2011.Q3],[2011.Q4],
[2012.Q1],[2012.Q2],[2012.Q3],[2012.Q4],[2013.Q1],[2013.Q2],[2013.Q3],[2013.Q4],
[2014.Q1],[2014.Q2],[2014.Q3],[2014.Q4],[2015.Q1],[2015.Q2],[2015.Q3],[2015.Q4],
[2016.Q1],[2016.Q2],[2016.Q3],[2016.Q4],[2017.Q1],[2017.Q2],[2017.Q3],[2017.Q4],
[2018.Q1],[2018.Q2],[2018.Q3],[2018.Q4],[2019.Q1],[2019.Q2],[2019.Q3],[2019.Q4],
[2020.Q1],[2020.Q2],[2020.Q3],[2020.Q4],[2021.Q1],[2021.Q2],[2021.Q3],[2021.Q4],
[2022.Q1],[2022.Q2],[2022.Q3],[2022.Q4],[2023.Q1],[2023.Q2],[2023.Q3],[2023.Q4],
[2024.Q1])
) AS UPT

SELECT freq, unit, geo, Period,DW_EXST,DW_NEW,TOTAL
INTO dbo.[IBZ_House_price_index_PIVOT]
FROM 
(SELECT freq, unit,purchase, geo,[Amount], Period FROM [#IBZ_House_price_index]) AS IQ
PIVOT (
SUM([Amount]) FOR purchase IN (DW_EXST,DW_NEW,TOTAL))AS PT

-- [dbo].[IBZ_House_price_index_Item_weights]
SELECT * 
INTO #IBZ_House_price_index_Item_weights
FROM [dbo].[IBZ_House_price_index_Item_weights]
  UNPIVOT
	(
	[Amount] FOR [Period] IN ([2010]
      ,[2011]
      ,[2012]
      ,[2013]
      ,[2014]
      ,[2015]
      ,[2016]
      ,[2017]
      ,[2018]
      ,[2019]
      ,[2020]
      ,[2021]
      ,[2022]
      ,[2023]
	  ,[2024])
	) AS UPT 

SELECT freq, geo, Period,DW_XST,DW_NW
INTO [dbo].[IBZ_House_price_index_Item_weights_PIVOT]
FROM 
(SELECT freq,purchase, geo,[Amount], Period FROM #IBZ_House_price_index_Item_weights) AS IQ
PIVOT (
SUM([Amount]) FOR purchase IN (DW_XST,DW_NW))AS PT

--[dbo].[IBZ_House_sales_number_and_index]
SELECT * 
INTO #IBZ_House_sales_number_and_index
FROM [dbo].[IBZ_House_sales_number_and_index]
UNPIVOT
	(
	[Amount] FOR [Period] IN (
[2010.Q1],[2010.Q2],[2010.Q3],[2010.Q4],[2011.Q1],[2011.Q2],[2011.Q3],[2011.Q4],
[2012.Q1],[2012.Q2],[2012.Q3],[2012.Q4],[2013.Q1],[2013.Q2],[2013.Q3],[2013.Q4],
[2014.Q1],[2014.Q2],[2014.Q3],[2014.Q4],[2015.Q1],[2015.Q2],[2015.Q3],[2015.Q4],
[2016.Q1],[2016.Q2],[2016.Q3],[2016.Q4],[2017.Q1],[2017.Q2],[2017.Q3],[2017.Q4],
[2018.Q1],[2018.Q2],[2018.Q3],[2018.Q4],[2019.Q1],[2019.Q2],[2019.Q3],[2019.Q4],
[2020.Q1],[2020.Q2],[2020.Q3],[2020.Q4],[2021.Q1],[2021.Q2],[2021.Q3],[2021.Q4],
[2022.Q1],[2022.Q2],[2022.Q3],[2022.Q4],[2023.Q1],[2023.Q2],[2023.Q3],[2023.Q4],
[2024.Q1])
) AS UPT



SELECT freq, unit, geo, Period,DW_EXST,DW_NEW,TOTAL
INTO dbo.[IBZ_House_sales_number_and_index_PIVOT]
FROM 
(SELECT freq, unit,purchase, geo,[Amount], Period FROM #IBZ_House_sales_number_and_index) AS IQ
PIVOT (
SUM([Amount]) FOR purchase IN (DW_EXST,DW_NEW,TOTAL))AS PT

--SELECT * FROM dbo.[IBZ_House_sales_number_and_index] WHERE geo LIKE '%es%' AND purchase = 'total'
--SELECT * FROM [dbo].[IBZ_House_price_index] WHERE geo ='es'AND purchase = 'total'

--[dbo].[IBZ_Owner_occupied_housing_price_index_country_weights]
SELECT * 
INTO #IBZ_Owner_occupied_housing_price_index_country_weights
FROM [dbo].[IBZ_Owner_occupied_housing_price_index_country_weights]
  UNPIVOT
	(
	[Amount] FOR [Period] IN ([2010]
      ,[2011]
      ,[2012]
      ,[2013]
      ,[2014]
      ,[2015]
      ,[2016]
      ,[2017]
      ,[2018]
      ,[2019]
      ,[2020]
      ,[2021]
      ,[2022]
      ,[2023]
	  ,[2024])
	) AS UPT 
WHERE statinfo = 'COWEU27_2020'


SELECT freq,  geo, Period,DW_ACQ_EXST,DW_OWN,DW_OWN_INS,DW_ACQ_NEW,DW_ACQ,DW_OWN_OTH,DW_ACQ_OTH,TOTAL,DW_ACQ_NEWSB,DW_ACQ_NEWP,DW_OWN_RMNT
INTO  [dbo].[IBZ_Owner_occupied_housing_price_index_country_weights_PIVOT]
FROM 
(SELECT freq,expend, geo,[Amount], Period FROM #IBZ_Owner_occupied_housing_price_index_country_weights) AS IQ
PIVOT (
SUM([Amount]) FOR expend IN (DW_ACQ_EXST,DW_OWN,DW_OWN_INS,DW_ACQ_NEW,DW_ACQ,DW_OWN_OTH,DW_ACQ_OTH,TOTAL,DW_ACQ_NEWSB,DW_ACQ_NEWP,DW_OWN_RMNT))AS PT

