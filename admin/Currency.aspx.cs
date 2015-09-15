using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class admin_Currency : System.Web.UI.Page
{
  protected void Page_LoadComplete(object sender, EventArgs e)
  {
    txtCurrency.Text = Cart.Currency.ToString("0.00");
    txtCurrency.Enabled = !Cart.UseAutoUpdate;
    cbxIsAuto.Checked = Cart.UseAutoUpdate;
    try
    {
      CurrencyService.DailyInfoSoapClient client = new CurrencyService.DailyInfoSoapClient();
      DataSet ds = client.GetCursOnDate(DateTime.Now);
      lblCBRF.Text = CurrencyResponse.GetEuroCourse(CurrencyResponse.ParseDataSet(ds));
    }
    catch{}
  }

  protected void SaveCurrency(object sender, EventArgs e)
  {
    float c = 0;
    Cart.UseAutoUpdate = cbxIsAuto.Checked;
    if (!Cart.UseAutoUpdate)
    {
      if (float.TryParse(txtCurrency.Text.Replace(".", ","), out c))
      {
        Cart.Currency = c;
        txtMessage.Text = "Сохранено";
        txtCurrency.Text = c.ToString("0.00");
      }
      else
        txtMessage.Text = "Неверный формат введенных данных";
    }
    else
      Cart.CurrencyUpdated = new DateTime(1, 1, 1);
    //else
    //{
    //  try
    //  {
    //    CurrencyService.DailyInfoSoapClient client = new CurrencyService.DailyInfoSoapClient();
    //    DataSet ds = client.GetCursOnDate(DateTime.Now);
    //    Cart.Currency = c;
    //    float.TryParse(CurrencyResponse.GetEuroCourse(CurrencyResponse.ParseDataSet(ds)), out c);
    //  }
    //  catch { }
    //}
  }
}