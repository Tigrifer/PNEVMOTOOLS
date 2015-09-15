<%@ WebHandler Language="C#" Class="ImageUploadHandler" %>

using System;
using System.Web;

public class ImageUploadHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
      
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}