<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="CartPage.aspx.cs" Inherits="CartPage" %>
<%@ Register Src="~/controls/Capcha.ascx" TagName="Captcha" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <%if (Request["accepted"] == "1"){%>
    <script type="text/javascript">
      alert("Заказ принят к исполнению. В ближайшее время Вы получите сообщение на указанный в форме заказа номер телефона. После чего с Вами свяжется менеджер для подтверждения заказа.");
    </script>
  <%}%>
  <table style="margin:0 auto;width:100%;">
    <tr>
      <td class="content_right">
        <div class="bordered">
          <table class="details_table">
            <tr>
              <th width="145px">Товары</th>
              <th>Описание</th>
              <th width="85px">Цена</th>
              <th width="85px">Оптовая</th>
              <th width="130px">Количество</th>
              <th width="95px">Общая цена</th>
              <th width="40px"></th>
            </tr>
            <asp:ListView ID="lvCartItems" runat="server">
              <ItemTemplate>
              <tr style="text-align:center;">
                <td style="text-align:left;">
                  <a class="linkCart" href="/Details.aspx?id=<%#Eval("ID")%>"><%#Eval("Name")%></a>
                </td>
                <td style="text-align:left;">
                  <%#Eval("ShortDescription")%>
                </td>
                <td><%#Eval("Price")%> р.</td>
                <td style="font-size:11px;"><%#Eval("WholePrice")%>р. от <%#Eval("WholeMin")%>шт.</td>
                <td>
                  <div class="smallPricer" style="float:right;">
                    <div class="smallPricerCount"><input type="text" value='<%#Eval("Count")%>' id='pricerCount<%#Eval("ID")%>' onchange="CheckValue(this);"
                      minwhole='<%#Eval("WholeMin")%>' wholeprice='<%#Eval("WholePrice")%>' price='<%#Eval("Price")%>'/></div>
                    <div class="smallPricerInc" onclick='IncrementValue("#pricerCount<%#Eval("ID")%>");'></div>
                    <div class="smallPricerBuy" style="padding:2px 0 0;" onclick="UpdateCart(<%#Eval("ID")%>, $('#pricerCount<%#Eval("ID")%>').val());">
                      <img src="/img/cartRefresh.png" alt="обновить" />
                    </div>
                    <div class="smallPricerDec" onclick='DecrementValue("#pricerCount<%#Eval("ID")%>");'></div>
                  </div>
                </td>
                <td id="tdTotalPrice<%#Eval("ID")%>"><%#Eval("TotalPrice")%> р.</td>
                <td><img onclick="DeleteCart(<%#Eval("ID")%>, this); return false;" alt="Удалить" src="/img/deleteCart.png" style="cursor:pointer;"/></td>
              </tr>
              </ItemTemplate>
              <EmptyDataTemplate>
                <h3 style="text-align:center;">Корзина пуста.</h3>
              </EmptyDataTemplate>
            </asp:ListView>
            <tr runat="server" id="trDelivery" style="text-align:center;">
              <td colspan="4">Доставка:</td>
              <td></td>
              <td><asp:Label runat="server" ID="lblDeliveryPrice" ClientIDMode="Static" /> р.</td>
              <td></td>
            </tr>
            <tr runat="server" id="trSummary" style="text-align:center;">
              <td colspan="4"><b>Всего: </b></td>
              <td><asp:Label runat="server" ID="lblTotalCount" ClientIDMode="Static"></asp:Label> шт.</td>
              <td><asp:Label ID="lblTotalPrice" runat="server" ClientIDMode="Static"></asp:Label> р.</td>
              <td></td>
            </tr>
          </table>
          <div runat="server" id="divMakeOrder">
            <h4>Оформление заказа:</h4>
            <table class="order_table">
              <tr><td colspan="3" align="right"><b style="cursor:pointer;" class="linkCart" onclick="ClearOrderForm();">Очистить форму заказа</b></td></tr>
              <tr>
                <td style="width:110px;">Имя</td>
                <td style="width:2px;">:</td>
                <td>
                  <asp:TextBox ID="txtName" runat="server"/><asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" ForeColor="Red" Text="*" ValidationGroup="Order" SetFocusOnError="true" />
                  <sub>Пример: Дмитрий Валентинович</sub>
                </td>
              </tr>
              <tr>
                <td>E-Mail</td>
                <td>:</td>
                <td>
                  <asp:TextBox ID="txtEmail" runat="server"/><asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ForeColor="Red" Text="*" ValidationGroup="Order" SetFocusOnError="true"/>
                  <sub>Пример: example@global.com</sub>
                </td>
              </tr>
              <tr>
                <td>Телефон</td>
                <td>:</td>
                <td>
                  <asp:TextBox ID="txtPhone" runat="server"/><asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" ForeColor="Red" Text="*" ValidationGroup="Order" SetFocusOnError="true"/>
                  <sub>Пример: +79872221133</sub>
                </td>
              </tr>
              <tr>
                <td>Второй телефон</td>
                <td>:</td>
                <td>
                  <asp:TextBox ID="txtPhone2" runat="server"/>
                  <sub>Пример: +79873332211</sub>
                </td>
              </tr>
              <tr>
                <td>Город</td>
                <td>:</td>
                <td>
                  <asp:TextBox ID="txtCity" runat="server"/><asp:RequiredFieldValidator runat="server" ControlToValidate="txtCity" ForeColor="Red" Text="*" ValidationGroup="Order" SetFocusOnError="true"/>
                  <sub>Пример: Москва</sub>
                </td>
              </tr>
              <tr>
                <td>Улица</td>
                <td>:</td>
                <td>
                  <asp:TextBox ID="txtStreet" runat="server"/><asp:RequiredFieldValidator runat="server" ControlToValidate="txtStreet" ForeColor="Red" Text="*" ValidationGroup="Order" SetFocusOnError="true"/>
                  <sub>Пример: Ленина</sub>
                </td>
              </tr>
              <tr>
                <td>Дом</td>
                <td>:</td>
                <td>
                  <asp:TextBox ID="txtBuilding" runat="server"/><asp:RequiredFieldValidator runat="server" ControlToValidate="txtBuilding" ForeColor="Red" Text="*" ValidationGroup="Order" SetFocusOnError="true"/>
                  <sub>Пример: 72Б, 112/2</sub>
                </td>
              </tr>
              <tr>
                <td>Квартира</td>
                <td>:</td>
                <td>
                  <asp:TextBox ID="txtAppartment" runat="server"/><asp:RequiredFieldValidator runat="server" ControlToValidate="txtAppartment" ForeColor="Red" Text="*" ValidationGroup="Order" SetFocusOnError="true"/>
                  <sub>Пример: 1205</sub>
                </td>
              </tr>
              <tr>
                <td>Примечания</td>
                <td>:</td>
                <td>
                  <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="7"/>
                  <sub>Пример: домофон не работает, позвонить заранее, во дворе злая собака.</sub>
                </td>
              </tr>
              <tr>
                <td>Введите код</td>
                <td>:</td>
                <td><uc:Captcha runat="server" ValidationGroup="order" /></td>
              </tr>
              <tr>
                <td></td>
                <td></td>
                <td>
                  <div runat="server" onclick="$('#btnOrder').click();" style="cursor:pointer;">
                    <div class="makeOrderBtn">Оформить заказ</div>
                  </div>
                  <asp:Button runat="server" ID="btnOrder" ClientIDMode="Static" OnClick="btnOrder_Click" style="display:none;" ValidationGroup="Order"/>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </td>
    </tr>
  </table>
  <script type="text/javascript">
    $(".order_table input").change(function () {
      $.cookie(this.id, $(this).val());
    });
    $(document).ready(function () {
      $(".order_table input").each(function () {
        var val = $.cookie(this.id);
        if (val)
          $(this).val(val);
      });
    });
  </script>
</asp:Content>

