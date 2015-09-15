using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Rezba : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
      using (DBDataContext DB = new DBDataContext())
      {
        lvRez.DataSource = (from C in DB.Rezbas select C).ToArray();
        lvRez.DataBind();
      }
    }
}