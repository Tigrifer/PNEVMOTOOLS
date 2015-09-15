using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Cities : System.Web.UI.Page
{
  protected void Page_LoadComplete(object sender, EventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      lvCities.DataSource = db.Cities.OrderBy(C => C.Name).ToArray();
      lvCities.DataBind();
    }
  }

  protected void OnDelete(object sender, EventArgs e)
  {
    int id= 0;
    int.TryParse(((Button)sender).CommandArgument, out id);
    using (DBDataContext db = new DBDataContext())
    {
      City c = db.Cities.FirstOrDefault(C => C.ID == id);
      if (c == null)
        return;
      db.Cities.DeleteOnSubmit(c);
      db.SubmitChanges();
    }
  }

  protected void lvCities_ItemInserting(object sender, ListViewInsertEventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      string name = "";
      int DeliveryPrice = 0, FreeDelivery = 0;
      foreach (string key in e.Values.Keys)
      {
        if (e.Values[key] == null)
          continue;
        switch (key)
        {
          case "Name":
            name = e.Values[key].ToString();
            break;
          case "DeliveryPrice":
            int.TryParse(e.Values[key].ToString(), out DeliveryPrice);
            break;
          case "FreeDelivery":
            int.TryParse(e.Values[key].ToString(), out FreeDelivery);
            break;
        }
      }
      if (string.IsNullOrEmpty(name))
      {
        e.Cancel = true;
        return;
      }
      City c = new City();
      c.Name = name;
      c.FreeDelivery = FreeDelivery;
      c.DeliveryPrice = DeliveryPrice;
      db.Cities.InsertOnSubmit(c);
      db.SubmitChanges();
    }
    lvCities.EditIndex = -1;
  }

  protected void lvCities_ItemUpdating(object sender, ListViewUpdateEventArgs e)
  {
    using (DBDataContext db = new DBDataContext())
    {
      string name = "";
      int ID = 0, DeliveryPrice = 0, FreeDelivery = 0;
      foreach (string key in e.NewValues.Keys)
      {
        switch(key)
        {
          case "Name":
            name = e.NewValues[key].ToString();
            break;
          case "DeliveryPrice":
            int.TryParse(e.NewValues[key].ToString(), out DeliveryPrice);
            break;
          case "FreeDelivery":
            int.TryParse(e.NewValues[key].ToString(), out FreeDelivery);
            break;
          case "ID":
            int.TryParse(e.NewValues[key].ToString(), out ID);
            break;
        }
      }
      City c = db.Cities.First(C => C.ID == ID);
      c.Name = name;
      c.FreeDelivery = FreeDelivery;
      c.DeliveryPrice = DeliveryPrice;
      db.SubmitChanges();
    }
    lvCities.EditIndex = -1;
  }

  protected void lvCities_ItemCanceling(object sender, ListViewCancelEventArgs e)
  {
    lvCities.EditIndex = -1;
  }

  protected void lvCities_ItemEditing(object sender, ListViewEditEventArgs e)
  {

  }
}