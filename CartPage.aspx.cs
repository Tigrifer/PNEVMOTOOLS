using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CartPage : Cartable
{
    protected void Page_PreRender(object sender, EventArgs e)
    {
      using (DBDataContext DB = new DBDataContext())
      {
        Cart cart = Cart.GetCurrentCart();
        int[] cartIds = cart.Items.Select(CI => CI.ItemID).ToArray();
        var list = (from I in DB.Items
                    where cartIds.Contains(I.ID)
                    select new
                    {
                      ID = I.ID,
                      Name = I.Name,
                      Price = I.TotalPrice,
                      WholePrice = I.TotalWholePrice,
                      WholeMin = I.WholeMinCount,
                      ShortDescription = I.ShortDescription,
                      Count = cart.GetByItemID(I.ID).ItemCount
                    }).ToList();
        lvCartItems.DataSource = from I in list
                                 select new
                                 {
                                   I.ID,
                                   I.Name,
                                   I.WholeMin,
                                   I.Price,
                                   I.WholePrice,
                                   I.Count,
                                   TotalPrice = I.Count * (cart.Items.First(ITM => ITM.ItemID == I.ID).ItemCount < I.WholeMin ? I.Price : I.WholePrice),
                                   I.ShortDescription
                                 };
        lvCartItems.DataBind();

        CartResponse cr = new CartResponse();
        lblTotalCount.Text = cr.count.ToString();
        lblTotalPrice.Text = (cr.price + cr.delivery).ToString();
        trSummary.Visible = trDelivery.Visible = divMakeOrder.Visible = cr.count != 0;
        lblDeliveryPrice.Text = cr.delivery.ToString();
      }
    }

    protected void btnOrder_Click(object sender, EventArgs e)
    {
      using(DBDataContext db = new DBDataContext())
      {
        CartResponse cr = new CartResponse();
        Order o = new Order()
        {
          Appartmant = txtAppartment.Text.Trim(),
          Building = txtBuilding.Text.Trim(),
          City = txtCity.Text.Trim(),
          Comments = txtComment.Text.Trim(),
          CreatedOn = DateTime.Now,
          DeliveryCost = cr.delivery,
          Email = txtEmail.Text.Trim(),
          Name = txtName.Text.Trim(),
          Phone = txtPhone.Text.Trim(),
          Pnone2 = txtPhone2.Text.Trim(),
          Status = (int)OrderStatus.ZAKAZAN,
          Street = txtStreet.Text.Trim(),
        };
        db.Orders.InsertOnSubmit(o);
        db.SubmitChanges();
        Cart cart = Cart.GetCurrentCart();
        foreach (CartItem ci in cart.Items)
        {
          Item itm = db.Items.First(I=>I.ID == ci.ItemID);
          OrderDetail od = new OrderDetail()
          {
            ItemID = ci.ItemID,
            ItemCount = ci.ItemCount,
            Order = o,
            PricePerItem = itm.TotalPrice
          };
          db.OrderDetails.InsertOnSubmit(od);
        }
        db.SubmitChanges();
        SMSManager.SendSMSV2ToUser(o.Phone, o.ID, (cr.price + cr.delivery));
        SMSManager.SendSMSV2ToAdmin(o.Phone, o.Name, o.ID, cr.count, cr.price);
        cart.ClearCart();
      }
      Response.Redirect(ResolveUrl("~/CartPage.aspx?accepted=1"));
    }
}