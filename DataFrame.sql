SELECT * INTO #Convergence_indicators FROM [dbo].[IBZ_Convergence_indicators_PIVOT] WHERE geo = 'EU27_2007'
SELECT geo = 'EU27_2020',* INTO #euribor FROM [dbo].[IBZ_euribor]
SELECT * INTO #HICP_annual_data_average_index_and_rate_of_change FROM [dbo].[IBZ_HICP_annual_data_average_index_and_rate_of_change_PIVOT] WHERE geo = 'EU27_2020'
SELECT * INTO #House_price_index_Item_weights FROM [dbo].[IBZ_House_price_index_Item_weights_PIVOT]WHERE geo = 'EU27_2020'
SELECT * INTO #House_price_index FROM [dbo].[IBZ_House_price_index_PIVOT]WHERE geo = 'EU27_2020'
SELECT freq, geo = 'EU27_2020', period, DW_EXST = SUM(DW_EXST), DW_NEW = SUM(DW_NEW), TOTAL = SUM(TOTAL)
INTO #House_sales_number_and_index
 FROM [dbo].[IBZ_House_sales_number_and_index_PIVOT]WHERE unit ='NR'
 GROUP BY freq,  period

 
SELECT 
a.*,
b.CV_PLI,b.CV_VI_HAB,
c.INX_A_AVG,c.RCH_A_AVG,
d.DW_XST,d.DW_NW,
DW_EXST_ind = e.DW_EXST,DW_NEW_ind = e.DW_NEW,TOTAL_ind= e.TOTAL,
f.DW_EXST,f.DW_NEW, f.TOTAL
FROM  #euribor a 
LEFT JOIN #Convergence_indicators b ON  LEFT(a.Period ,4)= b.period
LEFT JOIN #HICP_annual_data_average_index_and_rate_of_change c ON LEFT(a.Period ,4)= c.period
LEFT JOIN #House_price_index_Item_weights d ON LEFT(a.Period ,4)= d.period
LEFT JOIN #House_price_index e ON a.Period = e.period AND unit = 'I15_Q'
LEFT JOIN #House_sales_number_and_index f ON a.Period = f.period

