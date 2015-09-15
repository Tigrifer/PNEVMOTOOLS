using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Sizes : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
      using (DBDataContext DB = new DBDataContext())
      {
        lvSizes.DataSource = (from C in DB.Sizes select C).ToArray();
        lvSizes.DataBind();
      }
    }
}