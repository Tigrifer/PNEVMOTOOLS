using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Сводное описание для Cartable
/// </summary>
public class Cartable : System.Web.UI.Page
{
	public Cartable()
	{
		
	}

  [WebMethod]
  public static CartResponse AddToCart(int itemId, int itemCount)
  {
    Cart cart = Cart.GetCurrentCart();
    cart.AddToCart(itemId, itemCount);
    return new CartResponse();
  }

  [WebMethod]
  public static CartResponse RemoveFromCart(int itemId)
  {
    Cart cart = Cart.GetCurrentCart();
    cart.RemoveFromCart(itemId);
    return new CartResponse();
  }

  [WebMethod]
  public static CartResponse UpdateCart(int itemId, int itemCount)
  {
    Cart cart = Cart.GetCurrentCart();
    cart.UpdateCart(itemId, itemCount);
    return new CartResponse();
  }
}