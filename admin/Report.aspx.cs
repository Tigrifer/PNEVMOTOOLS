using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Report : System.Web.UI.Page
{
  protected void Page_Load(object sender, EventArgs e)
  {
    if (!IsPostBack)
    {
      DateTime date = DateTime.Now;
      date = new DateTime(date.Year, date.Month, 1).AddMonths(-1);
      datefrom.Value = new DateTime(date.Year, date.Month, date.Day).ToString("dd-MM-yy");
      date = date.AddMonths(1).AddDays(-1);
      dateto.Value = new DateTime(date.Year, date.Month, date.Day, 23, 59, 59, 999).ToString("dd-MM-yy");
      mvReports.SetActiveView(vSales);
      BindSales();
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

  protected void ReportTypeChanged(object sender, EventArgs e)
  {
    if (rblReportType.SelectedValue == "1")
    {
      mvReports.SetActiveView(vSales);
      BindSales();
    }
    else
    {
      mvReports.SetActiveView(vOutlay);
      BindOutlay();
    }
  }

  private void BindSales()
  {
    using (DBDataContext DB = new DBDataContext())
    {
      var orders = (from O in DB.Orders
                    where O.Status == (int)OrderStatus.DOSTAVLEN &&
                    O.CreatedOn >= DateFrom && O.CreatedOn < DateTo
                    select new
                    {
                      ID = O.ID,
                      Email = O.Email,
                      Date = O.CreatedOn,
                      Delivery = O.DeliveryCost,
                      Amount = O.OrderDetails.Sum(OD => OD.PricePerItem * OD.ItemCount)
                    }).ToArray();
      if (orders.Length > 0)
      {
        totalDelivery.InnerHtml = string.Format("{0} р.", orders.Sum(O => O.Delivery));
        totalAmount.InnerHtml = string.Format("{0} р.", orders.Sum(O => O.Amount));
      }
      lvSales.DataSource = orders;
      lvSales.DataBind();
    }
  }

  protected void Refresh(object sender, EventArgs e)
  {
    switch (rblReportType.SelectedValue)
    {
      case "1":
        BindSales();
        break;
      case "2":
        BindOutlay();
        break;
    }
  }

  private void BindOutlay()
  {
    using (DBDataContext DB = new DBDataContext())
    {
      var income = (from IO in DB.IncomeOrders
                    where IO.Date >= DateFrom && IO.Date < DateTo
                    select new
                    {
                      ID = IO.ID,
                      ItemID = IO.ItemID,
                      Count = IO.ItemCount,
                      Date = IO.Date,
                      PricePerItem = IO.PricePerItem,
                      Amount = IO.ItemCount * IO.PricePerItem
                    }).ToArray();
      if (income.Length > 0)
      {
        outlayTotal.InnerHtml = string.Format("{0} р.", income.Sum(O => O.Amount));
      }
      lvOutlayBuy.DataSource = income;
      lvOutlayBuy.DataBind();
    }
  }
}