<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="admin_Default" MasterPageFile="~/admin/AdminMasterPage.master"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <script src="/js/jquery-1.10.0.min.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:MultiView runat="server" ID="mvItems">
      <asp:View runat="server" ID="vView">
        <div style="position:fixed;background:white; padding: 3px; text-align:center;">
          <asp:Button ID="Button1" runat="server" OnClick="ShowAddNewForm" Text="Добавить новый товар" />
        </div>
        <div>
          <table align="center" class="itemsTable" width="100%" style="margin-top:30px;">
            <tr>
              <th>№</th>
              <th>Название</th>
              <th>Категория</th>
              <th>Размер</th>
              <th>Резьба</th>
              <th>Цена</th>
              <th>Вес</th>
              <th>Описание</th>
              <th>На складе</th>
              <th>#</th>
              <th>#</th>
              <th>New</th>
            </tr>
            <tr>
              <td></td>
              <td>Фильтрация:</td>
              <td><asp:DropDownList runat="server" ID="ddlCategories" AutoPostBack="true" /></td>
              <td><asp:DropDownList runat="server" ID="ddlSizes" AutoPostBack="true" /></td>
              <td><asp:DropDownList runat="server" ID="ddlRezs" AutoPostBack="true" /></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <asp:ListView runat="server" ID="lvItems">
              <AlternatingItemTemplate>
              <tr style="background:#E5E5E5;">
                <td><%#Eval("ID")%><input type="checkbox" <%#Eval("Visible")%> onchange='UpdateVisibility(this, <%#Eval("ID")%>);' style="margin:0;"></td>
                <td><%#Eval("Name")%></td>
                <td><%#Eval("Category")%></td>
                <td><%#Eval("Size")%>мм</td>
                <td><%#Eval("Rez")%></td>
                <td>€<%#Eval("Price")%></td>
                <td><%#Eval("Weight")%>гр.</td>
                <td><%#Eval("Description")%></td>
                <td align="center"><%#Eval("StoreCount")%></td>
                <td><input type="button" value="Править" onclick='return Redirect(<%#Eval("ID")%>)' /></td>
                <td><asp:Button runat="server" CommandArgument='<%#Eval("ID")%>' OnClick="Delete" Text="Удалить" OnClientClick="return confirm('Уверены, что хотите удалить этот товар из продажи?');" /></td>
                <td><input type="checkbox" <%#Eval("UseInLister ")%> onclick='UpdateLister(this, <%#Eval("ID")%>)' /><br /></td>
              </tr>
              </AlternatingItemTemplate>
              <ItemTemplate>
              <tr>
                <td><%#Eval("ID")%><input type="checkbox" <%#Eval("Visible")%> onchange='UpdateVisibility(this, <%#Eval("ID")%>);' style="margin:0;"></td>
                <td><%#Eval("Name")%></td>
                <td><%#Eval("Category")%></td>
                <td><%#Eval("Size")%>мм</td>
                <td><%#Eval("Rez")%></td>
                <td>€<%#Eval("Price")%></td>
                <td><%#Eval("Weight")%>гр.</td>
                <td><%#Eval("Description")%></td>
                <td align="center"><%#Eval("StoreCount")%></td>
                <td><input type="button" onclick='return Redirect(<%#Eval("ID")%>)' value="Править" /></td>
                <td><asp:Button runat="server" CommandArgument='<%#Eval("ID")%>' OnClick="Delete" Text="Удалить" OnClientClick="return confirm('Уверены, что хотите удалить этот товар из продажи?');" /></td>
                <td><input type="checkbox" <%#Eval("UseInLister ")%> onclick='UpdateLister(this, <%#Eval("ID")%>)' /><br /></td>
              </tr>
              </ItemTemplate>
              <EmptyDataTemplate>
                <tr>
                  <td colspan="10">Товары еще не добавлены</td>
                </tr>
              </EmptyDataTemplate>
            </asp:ListView>
          </table>
        </div>
      </asp:View>
      <asp:View runat="server" ID="vEdit">
        <table align="center" class="itemsTable" width="700px">
          <tr>
            <th colspan="3">Добавить новый товар</th>
          </tr>
          <tr>
            <td style="width:60px;">Название</td>
            <td style="width:10px;">:</td>
            <td>
              <asp:TextBox runat="server" ID="txtName" />
              <asp:RequiredFieldValidator ValidationGroup="EditItem" runat="server" ForeColor="DarkRed" ControlToValidate="txtName" SetFocusOnError="true" Text="*" />
            </td>
          </tr>
          <tr>
            <td>Категория</td>
            <td>:</td>
            <td><asp:DropDownList runat="server" ID="ddlCategory" /></td>
          </tr>
          <tr>
            <td>Размер</td>
            <td>:</td>
            <td><asp:DropDownList runat="server" ID="ddlSize" /></td>
          </tr>
          <tr>
            <td>Резьба</td>
            <td>:</td>
            <td><asp:DropDownList runat="server" ID="ddlRez" /></td>
          </tr>
          <tr>
            <td>Цена</td>
            <td>:</td>
            <td>
              <asp:TextBox runat="server" ID="txtPrice" />
              <asp:RequiredFieldValidator ValidationGroup="EditItem" runat="server" ForeColor="DarkRed" ControlToValidate="txtPrice" SetFocusOnError="true" Text="*" />
            </td>
          </tr>
          <tr>
            <td>Вес</td>
            <td>:</td>
            <td>
              <asp:TextBox runat="server" ID="txtWeight" /> гр.
              <asp:RequiredFieldValidator ValidationGroup="EditItem" runat="server" ForeColor="DarkRed" ControlToValidate="txtWeight" SetFocusOnError="true" Text="*" />
            </td>
          </tr>
          <tr>
            <td>Краткое описание</td>
            <td>:</td>
            <td><asp:TextBox runat="server" ID="txtShortDescription" TextMode="MultiLine" style="width:224px;height:32px;font-size: 12px;font-family:"/></td>
          </tr>
          <tr>
            <td>Описание</td>
            <td>:</td>
            <td><asp:TextBox runat="server" ID="txtDescription" Rows="5" TextMode="MultiLine" /></td>
          </tr>
          <tr>
            <td colspan="3">
              <asp:ListView ID="lvImages" runat="server">
                <EmptyDataTemplate>Изображения пока не загружены.</EmptyDataTemplate>
                <ItemTemplate>
                  <div style="float:left;" id="imgdiv<%#Eval("ID")%>">
                    <img alt="" src='<%#Eval("path")%>' width="100px" /><br />
                    <span class="deleteImage" onclick='DeleteImage(<%#Eval("ID")%>)'>Удалить</span>
                  </div>
                </ItemTemplate>
              </asp:ListView>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <div id="divImageContainer">
                <div>
                  <asp:FileUpload runat="server" ID="fuFile1" />
                  <asp:FileUpload runat="server" ID="fuFile2" />
                  <asp:FileUpload runat="server" ID="fuFile3" />
                  <asp:FileUpload runat="server" ID="fuFile4" />
                  <asp:FileUpload runat="server" ID="fuFile5" />
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td colspan="3" align="right">
              <asp:Button UseSubmitBehavior="true" runat="server" ID="btnAdd" Text="Добавить" OnClick="OnAdd" ValidationGroup="EditItem" />
              <asp:Button runat="server" Text="Отмена" OnClick="Cancel" />
            </td>
          </tr>
        </table>
        <br /><br />
        <table align="center" class="itemsTable" width="700px">
          <tr>
            <th colspan="2">Добавить на склад</th>
          </tr>
          <tr>
            <td colspan="2" style="font-weight:bold;text-decoration:underline;color:green;">Сейчас на складе: <asp:Label runat="server" ID="lblItemsCount" ForeColor="Purple" /></td>
          </tr>
          <tr>
            <td>Количество:</td>
            <td>
              <asp:TextBox runat="server" ID="txtIncomeCount" ValidationGroup="AddToStore" ClientIDMode="Static" onchange="StoreChanged();"/>
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtIncomeCount" ValidationGroup="AddToStore" />
            </td>
          </tr>
          <tr>
            <td>Цена за штуку:</td>
            <td>
              <asp:TextBox runat="server" ID="txtIncomePricePerItem" ValidationGroup="AddToStore" ClientIDMode="Static" onchange="StoreChanged();"/> руб.
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtIncomePricePerItem" ValidationGroup="AddToStore"/>
            </td>
          </tr>
          <tr>
            <td colspan="2">Итого: <span id="lblTotalPrice">0</span> руб.</td>
          </tr>
          <tr>
            <td colspan="2"><asp:Button runat="server" ID="btnAddToStore" OnClick="OnAddToStore" ValidationGroup="AddToStore" Text="Добавить товар на склад"/></td>
          </tr>
        </table>
      </asp:View>
    </asp:MultiView>
    <script type="text/javascript">
      var files;
      function DeleteImage(id) {
        PageMethods.DeleteImage(id, function () {
          $("#imgdiv" + id).remove();
        });
      }

      function UpdateLister(obj, id) {
        PageMethods.UpdateLister(id, function (result) {
          $(obj).prop("checked", result);
        });
      }

      function UpdateVisibility(obj, id) {
        var checked = $(obj).prop("checked");
        PageMethods.UpdateVisibility(id, checked, null);
      }

      function Redirect(id) {
        document.location = '/admin/Default.aspx?id=' + id;
        return false;
      }

      function StoreChanged() {
        var total = CheckIsNaN();
        $("#lblTotalPrice").html(total);
      }

      function CheckIsNaN() {
        var count = $("#txtIncomeCount").val();
        var price = $("#txtIncomePricePerItem").val();
        if (isNaN(count)) {
          $("#txtIncomeCount").val("0");
          return false;
        }
        if (isNaN(price)) {
          $("#txtPricePerItem").val("0");
          return false;
        }
        return count * price;
      }
    </script>
</asp:Content>