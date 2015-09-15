<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Capcha.ascx.cs" Inherits="Controls_Capcha" %>
<script language="javascript" type="text/javascript">
  function Reload() {
    var obj = document.getElementById("imgCapcha");
    var src = '<%=ResolveUrl("~/Controls/Capcha.ashx")%>?' + Math.random();
    obj.src = src;
  }
</script>
����������, ������� ���(5 ����):<br />
<div>
  <img style="cursor:pointer;" alt="���" id="imgCapcha" onclick="Reload();" src="/controls/Capcha.ashx"/>
  <img style="cursor:pointer;" alt="��������" src="/img/c_refresh.png" onclick="Reload();" title="�������� ���" />
</div>
<asp:TextBox ID="txtCapcha" runat="server" MaxLength="5" autocomplete="off" Width="60px" />
<asp:Label ForeColor="red" ID="lblErr" runat="server" />
<asp:RequiredFieldValidator ID="valCapcha" ControlToValidate="txtCapcha" ForeColor="DarkRed" runat="server" Text="*" SetFocusOnError="true"/>