using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Сводное описание для ItemExtender
/// </summary>
public partial class Item
{
  public int TotalPrice
  {
    get
    {
      if (MarginType == 0)
        return (int)Math.Round(Cart.Currency * Price * (100 + MarginValue) / 100);
      else
        return (int)Math.Round(Cart.Currency * Price + MarginValue);
    }
  }

  public int TotalWholePrice
  {
    get
    {
      if (MarginType == 0)
        return (int)Math.Round(Cart.Currency * Price * (100 + WholeMarginValue) / 100);
      else
        return (int)Math.Round(Cart.Currency * Price + WholeMarginValue);
    }
  }
}