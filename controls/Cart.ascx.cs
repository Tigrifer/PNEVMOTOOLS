using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class controls_Cart : System.Web.UI.UserControl
{
  protected void Page_Load(object sender, EventArgs e)
  {
    CartResponse cr = new CartResponse();
    CartItems.InnerText = Cart.GetCurrentCart().Items.Count == 0 ? "Корзина пуста" : string.Format("В корзине товаров: {0} На сумму: {1} руб.", cr.count, cr.price);
  }
}