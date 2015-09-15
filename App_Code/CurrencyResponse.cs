using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Сводное описание для CurrencyResponse
/// </summary>
public class CurrencyResponse
{
  public string Vname;// - Название валюты
  public string Vnom;// - Номинал
  public string Vcurs;// - Курс
  public string Vcode;// - Цифровой код валюты
  public string VchCode;// - Символьный код валюты

	public CurrencyResponse()
	{
	}

  public static List<CurrencyResponse> ParseDataSet(DataSet ds)
  {
    List<CurrencyResponse> list = new List<CurrencyResponse>();
    foreach(DataRow dr in ds.Tables[0].Rows)
    {
      CurrencyResponse cr = new CurrencyResponse()
      {
        VchCode = dr["VchCode"].ToString(),
        Vname = dr["Vname"].ToString(),
        Vcode = dr["Vcode"].ToString(),
        Vcurs = dr["Vcurs"].ToString(),
        Vnom = dr["Vnom"].ToString(),
      };
      list.Add(cr);
    }
    return list;
  }

  public static string GetEuroCourse(List<CurrencyResponse> list)
  {
    foreach (CurrencyResponse cr in list)
    {
      if (cr.VchCode == "EUR")
        return cr.Vcurs;
    }
    return "";
  }
}