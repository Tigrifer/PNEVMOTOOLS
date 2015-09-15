using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Web.Configuration;
using System.Data;

/// <summary>
/// Сводное описание для Cart
/// </summary>
public class Cart
{
  public static Cart GetCurrentCart()
  {
    return (HttpContext.Current.Session["Cart"] != null ? (Cart)HttpContext.Current.Session["Cart"] : new Cart());
  }

  public static string SelectedCity
  {
    get
    {
      return HttpContext.Current.Request.Cookies["selectedCityToDeliver"] != null ? HttpContext.Current.Request.Cookies["selectedCityToDeliver"].Value : null;
    }
  }

  public List<CartItem> Items = new List<CartItem>();
  static float _currency = 0;
  public static float Currency
  {
    get
    {
      if (UseAutoUpdate)
      {
        if (new DateTime(CurrencyUpdated.Year, CurrencyUpdated.Month, CurrencyUpdated.Day) < new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day))
        {
          try
          {
            CurrencyService.DailyInfoSoapClient client = new CurrencyService.DailyInfoSoapClient();
            DataSet ds = client.GetCursOnDate(DateTime.Now);
            float tCurrency = float.Parse(CurrencyResponse.GetEuroCourse(CurrencyResponse.ParseDataSet(ds)));
            if (tCurrency > 0)
            {
              CurrencyUpdated = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
              Currency = tCurrency;
            }
          }
          catch{}
        }
      }
      if (_currency == 0)
      {
        Configuration cnfg = WebConfigurationManager.OpenWebConfiguration("/currency.config");
        string c = cnfg.AppSettings.Settings["Currency"].Value;
        float.TryParse(c, out _currency);
      }
      return _currency;
    }
    set
    {
      _currency = value;
      Configuration cnfg = WebConfigurationManager.OpenWebConfiguration("/currency.config");
      string c = cnfg.AppSettings.Settings["Currency"].Value = _currency.ToString("0.00");
      cnfg.Save();
    }
  }

  static DateTime _currencyUpdated = new DateTime(1, 1, 1);
  public static DateTime CurrencyUpdated
  {
    get
    {
      if (_currencyUpdated == new DateTime(1, 1, 1))
      {
        Configuration cnfg = WebConfigurationManager.OpenWebConfiguration("/currency.config");
        string c = cnfg.AppSettings.Settings["Updated"].Value;
        DateTime.TryParse(c, out _currencyUpdated);
      }
      return _currencyUpdated;
    }
    set
    {
      _currencyUpdated = value;
      Configuration cnfg = WebConfigurationManager.OpenWebConfiguration("/currency.config");
      string c = cnfg.AppSettings.Settings["Updated"].Value = _currencyUpdated.ToShortDateString();
      cnfg.Save();
    }
  }

  static bool _useAutoUpdate = false;
  public static bool UseAutoUpdate
  {
    get
    {
      if (_useAutoUpdate == false)
      {
        Configuration cnfg = WebConfigurationManager.OpenWebConfiguration("/currency.config");
        string c = cnfg.AppSettings.Settings["IsAutomaticUpdate"].Value;
        bool.TryParse(c, out _useAutoUpdate);
      }
      return _useAutoUpdate;
    }
    set
    {
      _useAutoUpdate = value;
      Configuration cnfg = WebConfigurationManager.OpenWebConfiguration("/currency.config");
      string c = cnfg.AppSettings.Settings["IsAutomaticUpdate"].Value = _useAutoUpdate.ToString();
      cnfg.Save();
    }
  }

	public Cart(){}

  public CartItem GetByItemID(int id)
  {
    foreach (CartItem itm in Items)
      if (itm.ItemID == id)
        return itm;
    return null;
  }


  public void AddToCart(int itemId, int itemCount)
  {
    AddToCart(new CartItem(itemId, itemCount));
  }

  public void AddToCart(CartItem cItm)
  {
    CartItem itm = GetByItemID(cItm.ItemID);
    if (itm == null)
      Items.Add(cItm);
    else
      itm.ItemCount += cItm.ItemCount;
    HttpContext.Current.Session["Cart"] = this;
  }

  public void RemoveFromCart(int itemId)
  {
    CartItem itm = GetByItemID(itemId);
    if (itm != null)
      Items.Remove(itm);
    HttpContext.Current.Session["Cart"] = this;
  }

  public void UpdateCart(int id, int count)
  {
    UpdateCart(new CartItem(id, count));
  }

  public void UpdateCart(CartItem cItm)
  {
    CartItem itm = GetByItemID(cItm.ItemID);
    if (itm != null)
      itm.ItemCount = cItm.ItemCount;
    HttpContext.Current.Session["Cart"] = this;
  }

  public void ClearCart()
  {
    Items = new List<CartItem>();
    HttpContext.Current.Session["Cart"] = this;
  }
}

public class CartItem
{
  public CartItem() { }
  public CartItem(int itemID, int itemCount)
  {
    ItemID = itemID;
    ItemCount = itemCount;
  }
  public int ItemID;
  public int ItemCount;
}

public class CartResponse
{
  public int count;
  public int price;
  public int delivery;
  public CartResponse()
  {
    using(DBDataContext DB = new DBDataContext())
    {
      count = 0;
      price = 0;

      Item[] items = (from I in DB.Items
                      select I).ToArray();
      foreach (CartItem itm in Cart.GetCurrentCart().Items)
      {
        count += itm.ItemCount;
        Item Itm = items.Where(I => I.ID == itm.ItemID).FirstOrDefault();
        if (itm.ItemCount < Itm.WholeMinCount)
          price += (int)(Itm.TotalPrice * itm.ItemCount);
        else
          price += (int)(Itm.TotalWholePrice * itm.ItemCount);
      }

      if (Cart.SelectedCity != null)
      {
        City city;
        int cityID = int.Parse(Cart.SelectedCity);
        if (cityID != 0)
          city = DB.Cities.First(C => C.ID == cityID);
        else
          city = DB.Cities.FirstOrDefault();
        delivery = city.FreeDelivery < price ? 0 : city.DeliveryPrice;
      }
    }
  }
}