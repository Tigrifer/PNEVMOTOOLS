<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Cities.aspx.cs" Inherits="admin_Cities" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <table class="itemsTable">
    <tr>
      <th>Город</th>
      <th>Доставка</th>
      <th>Бесплатная доставка от</th>
      <th></th>
    </tr>
<asp:ListView ID="lvCities" runat="server" OnItemEditing="lvCities_ItemEditing" OnItemCanceling="lvCities_ItemCanceling"
  OnItemUpdating="lvCities_ItemUpdating" InsertItemPosition="FirstItem" OnItemInserting="lvCities_ItemInserting">
  <ItemTemplate>
    <tr>
      <td><%#Eval("Name")%></td>
      <td><%#Eval("DeliveryPrice")%> р.</td>
      <td><%#Eval("FreeDelivery")%> р.</td>
      <td>
        <asp:LinkButton ID="btnEdit" Text="Редактировать" runat="server" CommandName="Edit" ForeColor="Black" />
        <asp:Button runat="server" Text="Удалить" OnClick="OnDelete" CommandArgument='<%#Eval("ID")%>' OnClientClick="return confirm('Удалить город?');" />
      </td>
    </tr>
  </ItemTemplate>
  <EditItemTemplate>
    <tr>
      <td><asp:TextBox runat="server" ID="txtName" Text='<%#Bind("Name")%>'/></td>
      <td><asp:TextBox runat="server" ID="txtDeliveryPrice" Text='<%#Bind("DeliveryPrice")%>'/></td>
      <td><asp:TextBox runat="server" ID="txtFreeDelivery" Text='<%#Bind("FreeDelivery")%>'/></td>
      <td>
        <asp:LinkButton runat="server" Text="Сохранить" CommandName="Update" ForeColor="Black"/>
        <asp:LinkButton runat="server" Text="Отмена" CommandName="Cancel" ForeColor="Black"/>
        <asp:HiddenField runat="server" ID="hdnID" Value='<%#Bind("ID")%>' />
      </td>
    </tr>
  </EditItemTemplate>
  <InsertItemTemplate>
    <tr>
      <td><asp:TextBox runat="server" ID="txtName" Text='<%#Bind("Name")%>'/></td>
      <td><asp:TextBox runat="server" ID="txtDeliveryPrice" Text='<%#Bind("DeliveryPrice")%>'/></td>
      <td><asp:TextBox runat="server" ID="txtFreeDelivery" Text='<%#Bind("FreeDelivery")%>'/></td>
      <td>
        <asp:LinkButton runat="server" Text="Добавить" CommandName="Insert" ForeColor="Black"/>
      </td>
    </tr>
  </InsertItemTemplate>
</asp:ListView>
  </table>
</asp:Content>

