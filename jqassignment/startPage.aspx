<%--
    Assignment: A05 JQUERY JSON BASED TEXT EDITOR
    Student: Brandy Doan 8825910
    Date: Dec 06 2025
    Course: PROG2001 webdev - sean clarke
    Description: This file is the starting page that consists of a user's text editor. It uses Jquery AJAX to retrieve
                 files to be edited and also loads the file content's to be read. It allows for basic saving and Save As
                 when the user decides to enter a new name. It will alert the user of sucesses and failure and will
                 automatically load the files when the user selects one from the drop down list.
--%>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="startPage.aspx.cs" Inherits="jqassignment.startPage" EnableEventValidation="false" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title>

</title>
<link rel="stylesheet" href="style.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
    <script>
        //Initial page load ensures all functions are ready to use.
        $(document).ready(function () {

            loadFileList();

            $("#FileDropDown").change(function () {
                LoadText();
            });

            $("#openButton").click(function () {
                LoadText();
            });

            $("#saveButton").click(function () {
                SaveFile();
            });

            $("#SaveAsButton").click(function () {
                SaveAs();
            });
        });

        //==========================================
        //Function: loadFileList()
        //Description: Loads the list of available files into the dropdown menu.
        //             It sends an AJAX request to the server-side GetFileList method to retrieve the list of files.
        //fail   :     it alerts the user that the list failed to load
        //Parameters: None
        //==========================================
        function loadFileList() {
            $.ajax({
                url: "startPage.aspx/GetFileList", // Pass 'action' as a query string
                method: "POST",                     //post the action
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data: "{}", 

                success: function (files) {
                    var arrayFiles = files.d;
                    var dropList = $('#FileDropDown');
                    dropList.empty();
                    dropList.append(
                        $('<option>', { value: '', text: '-- Select a file --' })); //default option

                    $.each(arrayFiles, function (index, file) { //input the files recieved into the drop list
                        dropList.append(
                            $('<option>', { value: file, text: file }));
                    });

                },
                error: function (error) {
                    $("#status").text("Failed to load file list");
                }
            });
        }

        //==========================================
        //Function: LoadText()
        //Description: Loads the content of the selected file into the text editor.
        //             It sends an AJAX request to the server-side GetContent method with the file name to retrieve
        //             the content of
        //success:     it alerts the user that the file has been loaded sucessfully
        //fail   :     it alerts the user that the file has failed to load
        //Parameters: None
        //==========================================
        function LoadText()
        {
            console.log("LoadText() called!");

            var fileName = $("#FileDropDown").val();

            $.ajax({
                url: "startPage.aspx/GetContent",    // Pass getContent
                method: "POST",                      //post the action
                data: JSON.stringify({ name: fileName }),
                contentType: 'application/json; charset=utf-8',
                dataType: "json",

                success: function (response) {
                    var content = response.d;
                    $("#textEdit").val(content);
                    $("#status").text("Text sucessfuly loaded");
                },
                error: function (error) {
                    $("#status").text("Failed to load content");
                }
            })
        }

        //==========================================
        //Function: SaveFile()
        //Description: Saves the current content in the text editor to the selected file.
        //             It sends an AJAX request to the server-side Save method with the file name and content.
        //success:     it alerts the user that the file has been saved
        //Parameters: None
        //==========================================
        function SaveFile() {

            var fileName = $("#FileDropDown").val();
            var content = $("#textEdit").val();

            $.ajax({
                url: "startPage.aspx/Save",    // Pass getContent
                method: "POST",                      //post the action
                data: JSON.stringify({ name: fileName, body: content }),
                contentType: 'application/json; charset=utf-8',
                dataType: "json",

                success: function (response) {
                    $("#status").text(response.d);
                },
                error: function (error) {
                    $("#status").text("Failed to save");
                }
            })
        }

        //==========================================
        //Function: SaveAs()
        //Description: Saves the current content in the text editor to the new file name provided by the user.
        //             It sends an AJAX request to the server-side Save method with the new file name and content.
        //success:     it alerts the user that the file has been saved to the new file name
        //fail   :     it alerts the user that the save has failed, either due to blank name or invalid file extension
        //Parameters: None
        //==========================================
        function SaveAs() {
            var fileName = $("#saveAsName").val();
            var content = $("#textEdit").val();

            //send to server-side to save as new file
            $.ajax({
                url: "startPage.aspx/SaveAs",    // Pass SaveAs
                method: "POST",                      //post the action
                data: JSON.stringify({ name: fileName, body: content }),
                contentType: 'application/json; charset=utf-8',
                dataType: "json",

                success: function (response) {
                    loadFileList();
                    setTimeout(function () {
                        $("#FileDropDown").val(response.d);
                    }, 30); //allow list to load before selecting the new file name
                    $("#saveAsName").val("");
                    if (fileName == "") {
                        $("#status").text("Cannot save to a blank name.");
                    }
                    else if (response.d == null || response.d === null) {
                        $("#status").text("Failed to save. Please have a valid file extension");
                    }
                    else {
                        $("#status").text("Text saved to " + response.d);
                    }


                },
                error: function (error) {
                    $("#status").text("Failed to save to" + response.d);
                }
            })
        }   
    </script>
    <br /><br />

    <h1>Text Editor</h1>
<div class="row">
    <div class="column left"></div>
    
    <div class="column middle">

        <select class="dropDown" id="FileDropDown"></select>
        <button class="button" id="saveButton">Save</button>
        <label align="right" id="status"></label><br/>
        <textarea class="textBox" id="textEdit" rows="10"></textarea>

        <label for="saveAsName">File Name:</label>
        <input type="text" id="saveAsName"/>
        <button class="button" id="SaveAsButton">Save As</button>

    </div>
    
    <div class="column right"></div>
</div>
</body>
</html>
