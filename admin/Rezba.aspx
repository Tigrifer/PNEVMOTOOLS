<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Rezba.aspx.cs" Inherits="admin_Rezba" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <asp:MultiView runat="server" ID="mvRezba">
  <asp:View runat="server" ID="vAll">
    <div>
      <asp:Button runat="server" OnClick="AddSize" Text="Добавить новую резьбу" />
    </div>
    <table class="itemsTable" align="center">
      <tr>
        <th>Размер</th>
        <th>#</th>
        <th>#</th>
      </tr>
        <asp:ListView ID="lvSizes" runat="server">
          <ItemTemplate>
            <tr>
              <td><%#Eval("Name")%></td>
              <td><asp:Button runat="server" CommandArgument='<%#Eval("ID")%>' Text="Править" OnClick="EditSize" /></td>
              <td><asp:Button runat="server" CommandArgument='<%#Eval("ID")%>' Text="Удалить" OnClick="DeleteSize" OnClientClick="return confirm('Удалить резьбу?');" /></td>
            </tr>
          </ItemTemplate>
          <EmptyDataTemplate><tr><td>Резьбы недоступны.</td></tr></EmptyDataTemplate>
        </asp:ListView>
    </table>
  </asp:View>
  <asp:View runat="server" ID="vEdit">
    <table>
      <tr>
        <td>Резьба</td>
        <td>:</td>
        <td><asp:TextBox runat="server" ID="txtName" /></td>
      </tr>
      <tr>
        <td colspan="3" align="right">
          <asp:Button runat="server" OnClick="Add" Text="Сохранить" />
          <asp:Button runat="server" OnClick="Cancel" Text="Отмена" />
        </td>
      </tr>
    </table>
  </asp:View>
  </asp:MultiView>
</asp:Content>

