<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Cart.ascx.cs" Inherits="controls_Cart" %>
<div class="basket" onclick="location.href='/CartPage.aspx'">
  <div class="basketText" runat="server" id="CartItems" clientidmode="Static">Корзина пуста</div>
  <div class="basketImage"></div>
</div>