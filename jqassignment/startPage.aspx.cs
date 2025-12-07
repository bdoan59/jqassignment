/*
    Project: A05 JQUERY JSON BASED TEXT EDITOR
    File: startPage.ASPX.cs (behind code)
    Description: This file is the behind code for the startPage and holds the directory to the myFiles folder.
                 It holds functions to load, get files, load content, save as, and save
*/
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace jqassignment
{
    
    public partial class startPage : System.Web.UI.Page

    {
        public static string MyFilesPath = System.Web.HttpContext.Current.Server.MapPath("~/MyFiles");

        /*
         Function: protected void Page_Load(object sender, EventArgs e)
         Returns: void
         Description: This function is called when the page loads. It will check if the load is a postBack
                      and will prevent unnecessary reloads of content. 
         */
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
            }
        }

        /*
        Function: public string[] GetFileList()
        Returns: string array: holds all the files in the given directory
        Description: This will parse through and retrieve each file from the given file path. 
                     Saving it to a string array data structure so the client side of the program
                     can put it into the drop down list.
        */
        [WebMethod]
        public static string[] GetFileList()
        {
            return Directory.GetFiles(MyFilesPath)
                            .Select(Path.GetFileName)
                            .ToArray();
        }

        /*
        Function:GetContent(string name)
        Returns: string: text content of the text file OR null if failed
        Description: Receives a name to a file and checks if the file is existent in the given
                     directory. If not existent it returns null, if it exists it reads all of the
                     content in the file and returns it.
        */
        [WebMethod]
        public static string GetContent(string name)
        {
            string path = Path.Combine(MyFilesPath, name);

            if (!File.Exists(path))
            {
                return null;
            }

            string textFile = File.ReadAllText(path);
            return textFile;
        }

        /*
        Function: Save(string name, string body)
        Returns: string: success message
        Description: Will save text that the user has written in the text box into their chosen
                     text file from the drop down menu list. It will not append and will overwrite the
                     file from the start according to the users text
        */
        [WebMethod]
        public static string Save(string name, string body)
        {
            string path = Path.Combine(MyFilesPath, name);

            string file = $"{path}";

            using (System.IO.StreamWriter writer = new System.IO.StreamWriter(file, false))
            {
                writer.WriteLine(body);
            }
            string msg = "File Saved!";
            return msg;
        }

        /*
        Function: SaveAs(string name, string body)
        Returns: string: file name OR null if invalid
        Description: Will create a new file or overwrite completely given a file name that the user
                     enters. Then writes the contents that the user wrote in the editor text box.
        */
        [WebMethod]
        public static string SaveAs(string name, string body)
        {
            if (!name.Contains("."))
            {
                return null;
            }
            string path = Path.Combine(MyFilesPath, $"{name}");

            using (StreamWriter writer = new StreamWriter(path, false))
            {
                writer.WriteLine(body);
            }

            return name;
        }
    }

    
}