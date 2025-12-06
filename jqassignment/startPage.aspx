<%--
    Assignment: A05 JQUERY JSON BASED TEXT EDITOR
    Student: Brandy Doan 8825910 || 
    Date: Dec 06 2025
    Course: PROG2001 webdev - sean clarke
    Description: This file is the starting page that consists of a user's text editor. It uses Jquery AJAX to retrieve
                 files to be edited and also loads the file content's to be read. It allows for basic saving and Save As
                 when the user decides to enter a new name. 
--%>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="startPage.aspx.cs" Inherits="jqassignment.startPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title>

</title>
    <style>
    body { font-family:'Comic Sans MS'; text-align: center; background-color: aliceblue; }
    h1 { text-align:center; font-family:'Comic Sans MS'; color:palevioletred; }
    .textBox {
        font-size: 18px;
        border-width: 2px;
        color: brown;
        width: 60%;
        height: 130px;
        margin-top: 10px;
        margin-bottom: 10px;
        border-color: palevioletred;
        text-align: left;
        background-color: antiquewhite;
    }
    .button { 
        margin-top: 10px; 
        font-family:'Comic Sans MS'; 
        color: palevioletred;
        background-color: antiquewhite;
        font-size:20px;
    }
    .dropDown {
        font-size:20px; color:brown; font-family:'Comic Sans MS'; background-color:honeydew;
    }
        

</style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

</head>
<body>
    <script>

        $(document).ready(function () {
            loadFileList();

            $("#FileDropDown").click(function () {
                loadFileList(); // Automatically load files when the page is ready.
            });
        });

        $("#FileDropDown").click(function () {
            loadFileList(); // Automatically load files when the page is ready.
        });

        function loadFileList() {
            $.ajax({
                url: "startPage.aspx?GetFilesList", // Pass 'action' as a query string
                method: "POST",                     //post the action
                contentType: 'application/JSON',

                success: function (files) {
                    var arrayFiles = resp.data;
                    var dropList = $('FileDropDown');

                    dropList.find('option').each(function () { //empty the drop list entirely
                        $(this).remove();
                    });

                    $.each(arrayFiles, function (index, file) { //input the files recieved into the drop list
                        dropList.append($('<option>',{value: file,text: file}));
                    });

                },
                error: function (error) {
                    alert("Failed to load file list.");
                }
            });
        }

        $("openFile").click(function () {
            LoadText();
        });

        function LoadText()
        {
            var fileName = $("#FileDropDown").val();

            $.ajax({
                url: "startPage.aspx?GetContent",    // Pass getContent
                method: "POST",                      //post the action
                data: JSON.stringify({ name: fileName }),
                contentType: 'application/json',

                success: function (response) {
                    alert(response.val());
                    $("#textBox").val(response.data);
                },
                error: function (error) {
                    alert("Failed to load content.");
                }
            })
        }

        //$("#saveAs").click(function () {
        //    //send to server-side to save as new file
        //    $.ajax({
        //        url: "startPage.aspx?SaveAs",    // Pass SaveAs
        //        method: "POST",                      //post the action
        //        data: JSON.stringify({ name: $("#saveAsName").val(), content: $("#textBox").val() }),
        //        contentType: 'application/json',
        //        success: function (response) {
        //            alert("File saved successfully.");
        //        },
        //        error: function (error) {
        //            alert("Failed to save file.");
        //        }
        //    })
        //});
    </script>

    <h1>-ˋˏ ༻❁༺ ˎˊ-Text Editor-ˋˏ ༻❁༺ ˎˊ-</h1>
    <form runat="server">
        <div id="div1">
            <asp:Button class="button" id="openFile" onclick="openFile_Click" Text="Open File" runat="server"></asp:Button>
            <asp:DropDownList class="dropDown" ID="FileDropDown" runat="server" ></asp:DropDownList>
        </div>

        <div id="div2">
            <asp:TextBox class="textBox" TextMode="MultiLine" ID="textEdit" runat="server"/>
        </div>

        <div id="div3" runat="server">
            <asp:Button class="button" type="button" runat="server" id="save" onclick="SaveFile" Text="Save"></asp:Button><br><br>
        </div>

        <div id="div4">
            <label for="saveAsName">File Name:</label>
            <input runat="server" type="text" id="saveAsName" />
               <asp:RequiredFieldValidator ID="rfvSaveAs" runat="server" 
                   ErrorMessage="Please enter a name to save to" 
                   ControlToValidate="saveAsName" 
                   Display="Dynamic" 
                   ForeColor="Red" 
                   ValidationGroup="group1">
               </asp:RequiredFieldValidator>
            <asp:Button class="button" type="button" runat="server" id="saveAs" OnClick="SaveAs" Text="Save As"></asp:Button>

        </div>
    </form>
</body>
</html>
