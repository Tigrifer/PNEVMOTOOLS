<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Category.aspx.cs" Inherits="admin_Category" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <table class="itemsTable">
    <tr>
      <th>Главные категории</th>
      <th></th>
    </tr>
    <asp:ListView runat="server" ID="lvMainCategories">
      <ItemTemplate>
        <tr>
          <td onclick='EditCategoryName(<%#Eval("ID")%>, this);'><%#Eval("Name")%></td>
          <td>
            <asp:Button runat="server" CommandArgument='<%#Eval("ID")%>' OnClick="Up" Text="↑"/>
            <asp:Button runat="server" CommandArgument='<%#Eval("ID")%>' OnClick="Down" Text="↓"/>
            <asp:Button runat="server" OnClientClick="return confirm('Удалить?');" OnClick='DeleteCategory' CommandArgument='<%#Eval("ID")%>' Text="Удалить" />
          </td>
        </tr>
        <tr>
          <td colspan="2" style="border-bottom:2px solid Black;">
            <span style="cursor:pointer;color:Gray;font-size:12px;" onclick="OpenSub(this);" id='subcategory<%#Eval("ID")%>'>подкатегории ...</span>
            <table class="itemsTable" style="display:none; width:100%;">
            <asp:ListView runat="server" DataSource='<%#Eval("Categories")%>'>
              <ItemTemplate>
                <tr>
                  <td onclick='EditCategoryName(<%#Eval("ID")%>, this);'><%#Eval("Name")%></td>
                  <td>
                    <asp:Button runat="server" CommandArgument='<%#Eval("ID")%>' OnClick="Up" Text="↑"/>
                    <asp:Button runat="server" CommandArgument='<%#Eval("ID")%>' OnClick="Down" Text="↓"/>
                  </td>
                  <td><asp:Button runat="server" OnClientClick="return confirm('Удалить?');" OnClick='DeleteCategory' CommandArgument='<%#Eval("ID")%>' Text="Удалить" /></td>
                </tr>
              </ItemTemplate>
            </asp:ListView>
              <tr>
                <td><input id='txtNewCategory<%#Eval("ID")%>'/></td>
                <td><input type="button" onclick="AddCategory(<%#Eval("ID")%>, $('#txtNewCategory<%#Eval("ID")%>').val(), this); return false;" value="Добавить" /></td>
              </tr>
            </table>
          </td>
        </tr>
      </ItemTemplate>
    </asp:ListView>
    <tr>
      <td><input id="txtNewParentCategory"/></td>
      <td><input type="button" onclick="AddCategory(1, $('#txtNewParentCategory').val()); return false;" value="Добавить" /></td>
    </tr>
  </table>
  <script type="text/javascript">
    function OpenSub(obj) {
      if (!obj.hdn) {
        $(obj).next().show();
        obj.hdn = true;
      }
      else {
        $(obj).next().hide();
        obj.hdn = false;
      }
    }
    function EditCategoryName(id, obj) {
      if (obj.editing) return;
      obj.editing = true;
      var name = $(obj).html();
      var input = $("<input value='" + name + "' />");
      $(obj).html("");
      $(obj).append(input);
      input.focus();
      input.select();
      input.blur(function () {
        SaveName(id, obj, this);
      });
      input.keydown(function (event) { if (event.keyCode == 13) { this.blur(); return false; } });
    }

    function SaveName(id, parent, obj) {
      PageMethods.UpdateCategoryName(id, $(obj).val(), function () {
        $(parent).html($(obj).val());
        parent.editing = false;
      });
    }

    function AddCategory(parentID, name) {
      if ($.trim(name) == '')
        return;
      PageMethods.AddCategory(parentID, name, function () {
        location.href = "/admin/Category.aspx?id=" + parentID;
      });
    }

    $(document).ready(function () {
      $('#subcategory<%=Request["id"]%>').click();
      <%if (!string.IsNullOrEmpty(message)) {%>
      alert(<%=message%>);
      <%}%>
    });
  </script>
</asp:Content>

