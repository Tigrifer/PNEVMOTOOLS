using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;

public partial class _Default : Cartable
{
  protected void Page_Load(object sender, EventArgs e)
  {
    int p = 0;
    if (!string.IsNullOrEmpty(Request["p"]) && int.TryParse(Request["p"], out p))
      ucLister.Visible = false;
  }

  [WebMethod]
  public static string ApplyFilter(int[] cat, int[] size, int[] rez)
  {
    HttpContext.Current.Response.Cache.SetNoServerCaching();
    StringBuilder sb = new StringBuilder();
    using (DBDataContext db = new DBDataContext())
    {
      Item[] items = (from I in db.Items
                     where cat.Length == 0 || cat.Contains(I.Category)
                     select I).ToArray();
      int[] sizeIDs = items.Select(I => I.Size.HasValue ? I.Size.Value : 0).Distinct().Where(ID => ID != 0).ToArray();
      int[] rezIDs = items.Select(I => I.Rezba.HasValue ? I.Rezba.Value : 0).Distinct().Where(ID => ID != 0).ToArray();
      items = (from I in items
               where (size.Length == 0 && rez.Length == 0) ||
               (size.Length == 0 || (I.Size.HasValue && size.Contains(I.Size.Value))) &&
               (rez.Length == 0 || (I.Rezba.HasValue && rez.Contains(I.Rezba.Value)))
               select I).ToArray();
      if (items.Length == 0)
        sb.Append("<div style='text-align:center;margin-top:40px;font-size:12px;'>По Вашему запросу ничего не найдено.</div>");
      else
      {
        foreach (Item I in items)
        {
          string img = I.Pics.Count > 0 ? I.Pics.First().path : "/img/items/no_item_image.png";
          sb.AppendFormat(@"
  <div style='float:left;margin:10px 10px 10px 0;'>
    <div class='main_item' title='{4}'>
      <div class='main_item_image' {5}>
        <div class='itemPriceBG'>
          <img src='{6}' alt='' height='141px' />
          <div class='item_description_price'>
            {7} руб.<br />
            <span style='font-size:11px;color:darkred;'>{11}р.</span>
          </div>
        </div>
      </div>
      <div class='main_item_desc'>
        <div class='item_title'>{1}</div>
        <div class='item_short_description'>{9}</div>
        <div class='itemPriceDiv'>
          {7} руб.
          <div class='wholePrice'>от {10}шт: {11}р.</div>
        </div>
      </div>
      <div class='pricer'>
        <div class='pricerCount'><input type='text' value='1' id='pricerCount{0}' onchange='CheckValue(this);'/></div>
        <div class='pricerInc' onclick='IncrementValue({8});'></div>
        <div class='pricerBuy' onclick='AddToCart({0}, $({8}).val());'>КУПИТЬ</div>
        <div class='pricerDec' onclick='DecrementValue({8});'></div>
      </div>
    </div>
  </div>", I.ID,
             I.Name,
             I.Size.HasValue ? string.Format("Размер:&Oslash; {0}мм", I.Size1.Name) : "",
             (I.Rezba == null ? "" : ("Резьба: " + I.Rezba1.Name.ToString() + "<br />")),
             I.Description,
             string.Format("onclick=\"location.href='Details.aspx?id={0}'\"", I.ID),
             img,
             I.TotalPrice,
             string.Format("\"#pricerCount{0}\"", I.ID),
             string.IsNullOrEmpty(I.ShortDescription) ? "" : I.ShortDescription.Replace("\n", "<br/>"),
             I.WholeMinCount,
             I.TotalWholePrice);
        }
        sb.AppendFormat("<script type='text/javascript'>var sizeIDs = [{0}]; var rezIDs = [{1}]</script>", string.Join(",", sizeIDs), string.Join(",", rezIDs));
      }
    }
    return sb.ToString();
  }
}