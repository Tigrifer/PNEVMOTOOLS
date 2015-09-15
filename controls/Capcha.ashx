<%@ WebHandler Language="C#" Class="Capcha" %>

using System;
using System.Web;
using System.Drawing;

public class Capcha : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
  public void ProcessRequest(HttpContext context)
  {
    int digits = 5;
    System.Drawing.Bitmap objBMP = new System.Drawing.Bitmap(digits * 14, 25);
    System.Drawing.Graphics objGraphics = System.Drawing.Graphics.FromImage(objBMP);
    objGraphics.Clear(System.Drawing.Color.FromArgb(160, 215, 99));
    objGraphics.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAliasGridFit;
    //' Configure font to use for text
    string randomStr = "";
    int[] myIntArray = new int[digits];
    int x;

    Random autoRand = new Random();

    for (x = 0; x < digits; x++)
    {
      myIntArray[x] = autoRand.Next(0, 9);
      randomStr += (myIntArray[x].ToString());
      System.Drawing.Font objFont = new System.Drawing.Font("Arial", autoRand.Next(15, 20), System.Drawing.FontStyle.Bold);
      int step = x * 12;
      objGraphics.DrawString(myIntArray[x].ToString(), objFont, RandomBrush(autoRand.Next(0, 26)), step - 1 + autoRand.Next(0, 4), -2 + autoRand.Next(0, 6));
      objFont.Dispose();
    }
    objGraphics.RotateTransform(-15 + autoRand.Next(0, 30));
    //Create the random # and add it to our string 
    RandomLines(objGraphics);
    //This is to add the string to session cookie, to be compared later
    context.Session["capcha"] = randomStr;
    //' Set the content type and return the image
    //context.Response.Headers.Clear();
    context.Response.ContentType = "image/JPEG";
    objBMP.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
    context.Response.Flush();
    context.Response.End();
    objGraphics.Dispose();
    objBMP.Dispose();

  }

  private System.Drawing.Brush RandomBrush(int rnd)
  {
    System.Drawing.Brush[] braushArray = 
            {
                System.Drawing.Brushes.Black,
                System.Drawing.Brushes.Blue,
                System.Drawing.Brushes.Brown,
                System.Drawing.Brushes.Chocolate,
                System.Drawing.Brushes.Azure,
                System.Drawing.Brushes.DarkGreen,
                System.Drawing.Brushes.BlanchedAlmond,
                System.Drawing.Brushes.DarkRed,
                System.Drawing.Brushes.DarkGoldenrod,
                System.Drawing.Brushes.DarkOliveGreen,
                System.Drawing.Brushes.DarkSlateBlue,
                System.Drawing.Brushes.DarkSlateGray,
                System.Drawing.Brushes.DarkViolet,
                System.Drawing.Brushes.DarkBlue,
                System.Drawing.Brushes.Crimson,
                System.Drawing.Brushes.DimGray,
                System.Drawing.Brushes.Olive,
                System.Drawing.Brushes.SlateGray,
                System.Drawing.Brushes.DarkGoldenrod,
                System.Drawing.Brushes.Purple,
                System.Drawing.Brushes.Red,
                System.Drawing.Brushes.DarkOrchid,
                System.Drawing.Brushes.SeaGreen,
                System.Drawing.Brushes.SteelBlue,
                System.Drawing.Brushes.SlateGray,
                System.Drawing.Brushes.White
            };
    return braushArray[rnd];
  }

  private System.Drawing.Pen RandomPen(int rnd)
  {
    System.Drawing.Color[] braushArray = 
            {
                Color.Black,
                Color.Blue,
                Color.Brown,
                Color.Chocolate,
                Color.Coral,
                Color.DarkGreen,
                Color.DarkOrange,
                Color.DarkRed,
                Color.DarkSalmon,
                Color.DarkSeaGreen,
                Color.DarkSlateBlue,
                Color.DarkSlateGray,
                Color.DarkViolet,
                Color.ForestGreen,
                Color.Gold,
                Color.Lime,
                Color.Olive,
                Color.Orange,
                Color.OrangeRed,
                Color.Purple,
                Color.Red,
                Color.SandyBrown,
                Color.SeaGreen,
                Color.SteelBlue,
                Color.Tomato,
                Color.YellowGreen
            };
    return new Pen(braushArray[rnd]);

  }
  private void RandomLines(Graphics objGraphics)
  {
    Random autoRand = new Random();
    for (int i = 0; i < 10; i++)
      objGraphics.DrawLine(RandomPen(autoRand.Next(0, 26)), autoRand.Next(0, 75), autoRand.Next(0, 25), autoRand.Next(0, 75), autoRand.Next(0, 25));
  }

  public bool IsReusable
  {
    get
    {
      return false;
    }
  }
}