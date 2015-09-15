<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemContainer.ascx.cs" Inherits="controls_ItemContainer" %>
<div class="titleLeft"></div>
<div class="titleCenter">Продукты</div>
<div class="titleRight"></div>
<asp:ListView ID="lvItems" runat="server">
  <ItemTemplate>
    <div style="float:left;margin:10px 10px 10px 0;">
      <div class="main_item" title='<%#Eval("Description")%>'>
        <div class="main_item_image" onclick="location.href='Details.aspx?id=<%#Eval("ID")%>'">
          <div class="itemPriceBG">
            <img src='<%#Eval("Img")%>' alt="" height="141px" />
            <div class="item_description_price">
              <%#Eval("Price")%> руб.<br />
              <span style="font-size:11px;color:DarkRed;"><%#Eval("WholePrice")%>р.</span>
            </div>
          </div>
        </div>
        <div class="main_item_desc" onclick="location.href='Details.aspx?id=<%#Eval("ID")%>'">
          <div class="item_title"><%#Eval("Name")%></div>
          <div class="item_short_description">
            <%#Eval("ShortDescription")%>
          </div>
          <div class="itemPriceDiv"><%#Eval("Price")%>р. <div class="wholePrice">от <%#Eval("WholeMinCount")%>шт: <%#Eval("WholePrice")%>р.</div></div>
        </div>
        <div class="pricer">
          <div class="pricerCount"><input type="text" value="1" id='pricerCount<%#Eval("ID")%>' onchange="CheckValue(this);"/></div>
          <div class="pricerInc" onclick='IncrementValue("#pricerCount<%#Eval("ID")%>");'></div>
          <div class="pricerBuy" onclick="AddToCart(<%#Eval("ID")%>, $('#pricerCount<%#Eval("ID")%>').val());">КУПИТЬ</div>
          <div class="pricerDec" onclick='DecrementValue("#pricerCount<%#Eval("ID")%>");'></div>
        </div>
      </div>
    </div>
  </ItemTemplate>
</asp:ListView>
<h4 style="text-align:center; cursor:pointer;padding:15px;margin:5px;color:#777777;" onclick="ProccessDataItemFilter();" runat="server" id="h4ShowAll">ПОКАЗАТЬ ВСЕ</h4>