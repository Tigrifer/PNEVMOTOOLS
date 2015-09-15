using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class MasterPage : System.Web.UI.MasterPage
{
  protected void Page_Load(object sender, EventArgs e)
  {
    //Response.Redirect("/Developing.htm");
    using (DBDataContext db = new DBDataContext())
    {
      City[] cityList = (from CITY in db.Cities
                         orderby CITY.Name
                         select CITY).ToArray();
      ddlCities.DataSource = cityList;
      ddlCities.DataTextField = "Name";
      ddlCities.DataValueField = "ID";
      ddlCities.DataBind();
      foreach (ListItem li in ddlCities.Items)
      {
        li.Attributes.Add("dLimit", cityList.Where(C => C.ID == int.Parse(li.Value)).First().FreeDelivery.ToString());
        if (li.Value == Cart.SelectedCity)
        {
          li.Selected = true;
          txtDeliveryLimit.InnerText = li.Attributes["dLimit"];
        }
      }
      if (Request.Cookies["selectedCityToDeliver"] == null && ddlCities.Items.Count > 0)
      {
        txtDeliveryLimit.InnerText = ddlCities.Items[0].Attributes["dLimit"];
      }
    }
    CartResponse cr = new CartResponse();
    cartTotal.InnerHtml = cr.price.ToString();
    cartCount.InnerHtml = cr.count.ToString();
  }
  
}
