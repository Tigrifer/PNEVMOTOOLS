using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.Common;

public partial class admin_Orders : System.Web.UI.Page
{
  public string ClientMessage = "";
  protected void Page_Load(object sender, EventArgs e)
  {
    if (!IsPostBack)
    {
      DateTime date = DateTime.Now;
      date = new DateTime(date.Year, date.Month, 1).AddMonths(-1);
      datefrom.Value = new DateTime(date.Year, date.Month, date.Day).ToString("dd-MM-yy");
      date = date.AddMonths(1).AddDays(-1);
      dateto.Value = new DateTime(date.Year, date.Month, date.Day, 23, 59, 59, 999).ToString("dd-MM-yy");
    }
  }

  public DateTime DateFrom
  {
    get { return DateTime.Parse(datefrom.Value); }
  }

  public DateTime DateTo
  {
    get { return DateTime.Parse(dateto.Value).AddDays(1); }
  }

  public string GetAcceptButtonText(OrderStatus status)
  {
    switch ((OrderStatus)status)
    {
      case OrderStatus.ZAKAZAN: return "Принять";
      case OrderStatus.PRINYAT: return "Отгрузить";
      case OrderStatus.OTGRUZHEN: return "Доставлен";
      case OrderStatus.OTMENEN: return "Отменен";
      case OrderStatus.DOSTAVLEN: return "Вернуть";
      case OrderStatus.VOZVRASCHEN: return "Возвращен";
    }
    return "";
  }

  protected void Page_LoadComplete(object sender, EventArgs e)
  {
    int status = (int)OrderStatus.ZAKAZAN;
    int.TryParse(ddlStatus.SelectedValue, out status);
    using (DBDataContext db = new DBDataContext())
    {
      lvOrders.DataSource = from O in db.Orders
                            where O.Status == status && O.CreatedOn >= DateFrom && O.CreatedOn <= DateTo
                            select new
                            {
                              ID = O.ID,
                              Name = O.Name,
                              City = O.City,
                              Phone = O.Phone,
                              Total = O.OrderDetails.Sum(OD => OD.PricePerItem * OD.ItemCount) + O.DeliveryCost,
                              Delivery = O.DeliveryCost,
                              Details = O.OrderDetails,
                              Description = O.Comments,
                              Date = O.CreatedOn,
                              Address = string.Format("{0}, д. {1}, кв. {2}", O.Street, O.Building, O.Appartmant),
                              Email = O.Email,
                              ButtonText = GetAcceptButtonText((OrderStatus)O.Status),
                              Visible = ((OrderStatus)O.Status) == OrderStatus.VOZVRASCHEN || ((OrderStatus)O.Status) == OrderStatus.OTMENEN ? false : true
                            };
      lvOrders.DataBind();
    }
  }

  protected void OnDelete(object sender, EventArgs e)
  {
    int id;
    if (int.TryParse(((Button)sender).CommandArgument, out id))
    {
      using (DBDataContext db = new DBDataContext())
      {
        Order o = db.Orders.FirstOrDefault(O => O.ID == id);
        switch ((OrderStatus)o.Status)
        {
          case OrderStatus.ZAKAZAN:
          case OrderStatus.PRINYAT:
            o.Status = (int)OrderStatus.OTMENEN;
            break;
          case OrderStatus.OTGRUZHEN:
          case OrderStatus.DOSTAVLEN:
            o.Status = (int)OrderStatus.OTMENEN;
            List<IncomeOrder> ioList = new List<IncomeOrder>();
            foreach (OrderDetail od in o.OrderDetails)
            {
              IncomeOrder io = new IncomeOrder();
              io.Date = DateTime.Now;
              io.ItemID = od.ItemID;
              io.ItemCount = od.ItemCount;
              io.ItemsLeft = od.ItemCount;
              io.PricePerItem = (int)Math.Round(od.PricePerItem);
              ioList.Add(io);
            }
            db.IncomeOrders.InsertAllOnSubmit(ioList);
            break;
        }
        o.CreatedOn = DateTime.Now;
        db.SubmitChanges();
      }
    }
  }

  protected static string ShowDetails(int id)
  {
    return id.ToString() == HttpContext.Current.Request["id"] ? "" : "none";
  }

  protected void OnAccept(object sender, EventArgs e)
  {
    int id;
    if (int.TryParse(((Button)sender).CommandArgument, out id))
    {
      using (DBDataContext db = new DBDataContext())
      {
        db.Connection.Open();
        Order o = db.Orders.FirstOrDefault(O => O.ID == id);
        switch ((OrderStatus)o.Status)
        {
          case OrderStatus.ZAKAZAN:
            o.Status = (int)OrderStatus.PRINYAT;
            o.CreatedOn = DateTime.Now;
            db.SubmitChanges();
            break;
          case OrderStatus.PRINYAT:
            db.Transaction = db.Connection.BeginTransaction();
            o.Status = (int)OrderStatus.OTGRUZHEN;
            bool ok = true;
            foreach (OrderDetail od in o.OrderDetails)
            {
              if (od.Item.IncomeOrders.Sum(IO => IO.ItemsLeft) >= od.ItemCount)
              {
                int itemsToProcess = od.ItemCount;
                foreach (IncomeOrder io in od.Item.IncomeOrders.Where(IO => IO.ItemsLeft > 0))
                {
                  if (itemsToProcess <= 0)
                    break; // обработали все по позиции.
                  if (io.ItemsLeft >= itemsToProcess)
                  {
                    io.ItemsLeft -= itemsToProcess;
                    itemsToProcess = 0;
                  }
                  else
                  {
                    itemsToProcess -= io.ItemsLeft;
                    io.ItemsLeft = 0;
                  }
                  db.SubmitChanges();
                }
              }
              else
              {
                ok = false;
                ClientMessage = string.Format("Для отгрузки заказа со склада не хватает товара: {0} ID={1}. На складе осталось {2}шт.", od.Item.Name, od.ItemID, od.Item.IncomeOrders.Sum(IO => IO.ItemCount));
                // недостаточно товара на складе.
                break;
              }
            }
            if (ok)
            {
              o.CreatedOn = DateTime.Now;
              db.SubmitChanges();
              db.Transaction.Commit();
            }
            else
              db.Transaction.Rollback();
            break;
          case OrderStatus.OTGRUZHEN:
            o.CreatedOn = DateTime.Now;
            o.Status = (int)OrderStatus.DOSTAVLEN;
            db.SubmitChanges();
            break;
          case OrderStatus.DOSTAVLEN:
            o.Status = (int)OrderStatus.VOZVRASCHEN;
            o.CreatedOn = DateTime.Now;
            foreach (OrderDetail od in o.OrderDetails)
            {
              IncomeOrder io = new IncomeOrder()
              {
                Date = DateTime.Now,
                ItemCount = od.ItemCount,
                PricePerItem = (int)od.PricePerItem,
                ItemsLeft = od.ItemCount,
                ItemID = od.ItemID
              };
              db.IncomeOrders.InsertOnSubmit(io);
            }
            db.SubmitChanges();
            break;
        }
        db.Connection.Close();
      }
    }
  }

  [WebMethod]
  public static string UpdateOrderDetail(int id, int count, int price)
  {
    try
    {
      using (DBDataContext db = new DBDataContext())
      {
        OrderDetail od = db.OrderDetails.FirstOrDefault(OD => OD.ID == id);
        od.ItemCount = count;
        od.PricePerItem = price;
        db.SubmitChanges();
      }
    }
    catch(Exception ex)
    {
      return ex.Message;
    }
    return "ok";
  }

  [WebMethod]
  public static string DeleteOrderDetail(int id)
  {
    try
    {
      using (DBDataContext db = new DBDataContext())
      {
        OrderDetail od = db.OrderDetails.FirstOrDefault(OD => OD.ID == id);
        db.OrderDetails.DeleteOnSubmit(od);
        db.SubmitChanges();
      }
    }
    catch (Exception ex)
    {
      return ex.Message;
    }
    return "ok";
  }

  [WebMethod]
  public static string AddOrderDetail(int orderID, int itemID, int price, int count)
  {
    try
    {
      using (DBDataContext db = new DBDataContext())
      {
        Item itm = db.Items.FirstOrDefault(I=>I.ID == itemID);
        OrderDetail od = new OrderDetail()
        {
          ItemID = itemID,
          ItemCount = count,
          OrderID = orderID,
          PricePerItem = itm.TotalPrice
        };
        db.OrderDetails.InsertOnSubmit(od);
        db.SubmitChanges();
      }
    }
    catch (Exception ex)
    {
      return ex.Message;
    }
    return "ok";
  }
}