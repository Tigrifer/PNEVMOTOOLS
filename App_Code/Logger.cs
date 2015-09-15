using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

/// <summary>
/// Сводное описание для Logger
/// </summary>
public class Logger
{
	public Logger()
	{
		
	}

  public static void LogError(Exception ex, string message)
  {
    string root = HttpContext.Current.Server.MapPath("/admin/Log/Log.html");
    using (StreamWriter sw = File.AppendText(root))
    {
      sw.WriteLine("<table wisth='100%'><tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><</tr></table>", DateTime.Now, message, ex.Message, ex.StackTrace);
    }
  }
}