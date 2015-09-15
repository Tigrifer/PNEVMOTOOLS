<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Lister.ascx.cs" Inherits="controls_Lister" %>
<table>
  <tr><td class="topLister"></td></tr>
</table>
<table>
    <tr>
      <td style="width:37px;border-left:1px solid #D4D4D4;vertical-align:middle;">
        <div class="listerLeft" onclick="ScrolListerLeft(false);"></div>
      </td>
      <td style="height:240px;width:622px;overflow:hidden;">
        <div id="divLister" style="height:240px;width:622px;overflow:hidden;">
          <div id="lScrollContainer">
          <asp:ListView ID="lvItems" runat="server">
            <ItemTemplate>
              <div class="listerItemContainer" onclick="location.href='/Details.aspx?id=<%#Eval("ID")%>'">
                <div class="listerItemImage">
                  <img src="<%#Eval("Path")%>" alt="" width="250"/>
                </div>
                <div class="listerItemDescription">
                  <div class="category_title" style="font-size:22px;margin:0;padding:0;"><%#Eval("Name")%></div>
                  <span style="font-size:12px;"><%#Eval("Description")%></span>
                </div>
                <div class="pricerBuy" style="background:#96A127;border-radius:5px;" onclick="event.stopPropagation(); AddToCart(<%#Eval("ID")%>, 1);">КУПИТЬ</div>
                <div class="pricerPrice"><%#Eval("Price")%> руб.</div>
              </div>
            </ItemTemplate>
          </asp:ListView>
          </div>
        </div>
      </td>
      <td style="width:37px;border-right:1px solid #D4D4D4;vertical-align:middle;">
        <div class="listerRight" onclick="ScrolListerRight(false);"></div>
      </td>
    </tr>
    <tr><td colspan="3" class="bottomLister"></td></tr>
</table>
<script type="text/javascript" language="javascript">
  var listerCount=<%=listerCount%>;
  var listerStep = 622;
  var autoListDelay = 9000;
  var scrollSpeed = 800;
  $(document).ready(function(){
    $("#lScrollContainer").css("width", (listerStep * listerCount)+"px");
    setTimeout(function(){AutoList();}, autoListDelay);
  });
</script>