<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="admin_Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <link rel="Stylesheet" type="text/css" href="/css/jquery-ui.css"/>
  <script src="/js/jquery-ui.js" type="text/javascript"></script>
  <style type="text/css">
    .ui-datepicker table{font-size:10px !important;}
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <script type="text/javascript">
    function ChangeOrderDetail(id) {
      var ppi = $("#odppi_" + id).val();
      var count = $("#odic_" + id).val();
      $("#odtotal_" + id).html(parseInt(ppi * count));
    }
    function ResetDetails(id) {
      $("#odppi_" + id).val($("#odppi_" + id).attr("default"));
      $("#odic_" + id).val($("#odic_" + id).attr("default"));
      ChangeOrderDetail(id);
    }
    function UpdateOrderDetails(id, orderID) {
      var ppi = $("#odppi_" + id).val();
      var count = $("#odic_" + id).val();
      PageMethods.UpdateOrderDetail(id, count, ppi, function (response) {
        if (response == "ok") {
          location.href = "/admin/Orders.aspx?id=" + orderID;
        }
        else {
          alert(response);
          ResetDetails(id);
        }
      });
    }
    function DeleteOrderDetail(id, orderID) {
      PageMethods.DeleteOrderDetail(id, function (resp) {
        if (resp == "ok") {
          $("#trOrderDetail_" + id).remove();
          location.href = "/admin/Orders.aspx?id=" + orderID;
        }
        else
          alert(resp);
      });
    }

    function AddNewDetail(orderID) {
      var itemID = $("#newItemID_"+orderID).val();
      var price = $("#newItemPrice_" + orderID).val();
      var count = $("#newItemCount_" + orderID).val();
      PageMethods.AddOrderDetail(orderID, itemID, price, count, function (resp) {
        if (resp == "ok") {
          location.href = "/admin/Orders.aspx?id=" + orderID;
        }
        else
          alert(resp);
      });
    }

    $(document).ready(function () {
      var msg = '<%=ClientMessage%>';
      if (msg != '')
        alert(msg);
      $("#datefrom").datepicker({ dateFormat: 'dd-mm-yy' });
      $("#dateto").datepicker({ dateFormat: 'dd-mm-yy' });
    });
  </script>
    <table class="itemsTable">
      <tr>
        <td>
          Выбрать все со статусом:
          <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true">
            <asp:ListItem Selected="True" Text="Заказан" Value="1" />
            <asp:ListItem Text="Принят" Value="2" />
            <asp:ListItem Text="Отгружен" Value="3" />
            <asp:ListItem Text="Доставлен" Value="4" />
            <asp:ListItem Text="Возвращен" Value="5" />
            <asp:ListItem Text="Отменен" Value="6" />
          </asp:DropDownList>
        </td>
        <td><asp:Button UseSubmitBehavior="true" runat="server" Text="Обновить" /></td>
      </tr>
    </table>
    <table style="font-size:12px;">
      <tr>
        <td>
          От: <input type="text" id="datefrom" runat="server" clientidmode="Static"/>
        </td>
        <td>
          До: <input type="text" id="dateto" runat="server" clientidmode="Static"/>
        </td>
      </tr>
    </table>
    <table align="center" class="itemsTable" width="100%" style="margin-top:30px;">
      <tr>
        <th>№</th>
        <th>Имя</th>
        <th>Город</th>
        <th>Телефон</th>
        <th>Сумма заказа</th>
        <th>Доставка</th>
        <th width="150px">Адрес</th>
        <th>Email</th>
        <th>Дата заказа</th>
        <th></th>
        <th></th>
      </tr>
      <asp:ListView runat="server" ID="lvOrders">
        <EmptyDataTemplate>
          <tr>
            <td colspan="11">Нет заказов</td>
          </tr>
        </EmptyDataTemplate>
        <ItemTemplate>
          <tr class="OrderCells">
            <td>
              <a style="color:#000055;" onclick='$("#orderDetails<%#Eval("ID")%>").toggle();'><%#Eval("ID")%> подробнее</a><br />
              <a target="_blank" href='/admin/BillPrint.aspx?id=<%#Eval("ID")%>'>Печать чека</a>
            </td>
            <td><%#Eval("Name")%></td>
            <td><%#Eval("City")%></td>
            <td>
              <%#Eval("Phone")%>
              <div><%#Eval("Description")%></div>
            </td>
            <td><%#Eval("Total")%> р.</td>
            <td><sup><%#Eval("Delivery")%>р.</sup></td>
            <td><%#Eval("Address")%></td>
            <td><%#Eval("Email")%></td>
            <td><%#Eval("Date")%></td>
            <td><asp:Button runat="server" OnClick="OnDelete" CommandArgument='<%#Eval("ID")%>' Visible='<%#Eval("Visible")%>' OnClientClick="return confirm('Удалить заказ? Заказ будет перемещено в раздел Отменен.');" Text="Удалить" /></td>
            <td><asp:Button runat="server" OnClick="OnAccept" CommandArgument='<%#Eval("ID")%>' Visible='<%#Eval("Visible")%>' OnClientClick="return confirm('Обработать ордер к дальнейшему исполнению?');" Text='<%#Eval("ButtonText")%>' /></td>
          </tr>
          <tr id='orderDetails<%#Eval("ID")%>' style="display:<%#ShowDetails((int)Eval("ID"))%>;">
            <td colspan="11">
              <table class="itemsTable">
                <tr>
                  <th>№</th>
                  <th>Товар</th>
                  <th>Цена за единицу</th>
                  <th>Кол-во</th>
                  <th>На складе</th>
                  <th>Всего</th>
                  <th></th>
                  <th></th>
                  <th></th>
                </tr>
                <asp:ListView runat="server" DataSource='<%#Eval("Details")%>'>
                  <ItemTemplate>
                    <tr class="OrderCells" id='trOrderDetail_<%#Eval("ID")%>' style='background:#<%#((Item)Eval("Item")).IncomeOrders.Sum(IO=>IO.ItemsLeft) < (int)Eval("ItemCount")? "FFDDDD":""%>;'>
                      <td><%#Eval("ID")%></td>
                      <td><a title="<%#Eval("Item.Description")%>" href="/Details.aspx?id=<%#Eval("ItemID")%>" target="_blank"><%#Eval("Item.Name")%></a></td>
                      <td><input default='<%#Eval("PricePerItem")%>' onkeyup='ChangeOrderDetail(<%#Eval("ID")%>);' type="text" id="odppi_<%#Eval("ID")%>" value='<%#Eval("PricePerItem")%>' /> р.</td>
                      <td><input default='<%#Eval("ItemCount")%>' onkeyup='ChangeOrderDetail(<%#Eval("ID")%>);' type="text" id="odic_<%#Eval("ID")%>" value='<%#Eval("ItemCount")%>' /></td>
                      <td><%#((Item)Eval("Item")).IncomeOrders.Sum(IO => IO.ItemsLeft)%>шт.</td>
                      <td><span id='odtotal_<%#Eval("ID")%>'><%#(int)Eval("ItemCount")*(double)Eval("PricePerItem")%></span> р.</td>
                      <td><input type="button" value="Сброс" onclick='ResetDetails(<%#Eval("ID")%>);'/></td>
                      <td><a onclick='UpdateOrderDetails(<%#Eval("ID")%>, <%#Eval("OrderID")%>);'>Обновить</a></td>
                      <td><a onclick='if (!confirm("Удалить?")) return false; DeleteOrderDetail(<%#Eval("ID")%>, <%#Eval("OrderID")%>);'>Удалить</a></td>
                    </tr>
                  </ItemTemplate>
                </asp:ListView>
                <tr class="OrderCells" >
                  <td>Добавить новый:</td>
                  <td>ID: <input id="newItemID_<%#Eval("ID")%>" type="text" /></td>
                  <td>Цена: по базе<input style="display:none;" id="newItemPrice_<%#Eval("ID")%>" type="text" value="0"/></td>
                  <td>Кол-во: <input id="newItemCount_<%#Eval("ID")%>" type="text" value="1" /></td>
                  <td></td>
                  <td><a onclick='AddNewDetail(<%#Eval("ID")%>);'>Добавить</a></td>
                  <td></td>
                  <td></td>
                  <td></td>
                </tr>
              </table>
            </td>
          </tr>
        </ItemTemplate>
      </asp:ListView>
    </table>
</asp:Content>

