/*
    Project: A05 JQUERY JSON BASED TEXT EDITOR
    Students: Brandy Doan 8825910
    Date: Dec 06 2025
    Course: PROG2001 – WEB DESIGN AND DEVELOPMENT
    Prof: Sean
    Description: This file is the behind code for the startPage and holds the directory to the myFiles folder.
                 It holds functions to load, get files, load content, save as, and save, and a click function
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
        private string MyFilesPath = "C:/localWebSite/jqassignment/myFiles";

        /*
         Function: protected void Page_Load(object sender, EventArgs e)
         Returns: void
         Description: This function is called when the page loads. It will check if the load is a postBack
                      and will use the LoadFiles() function to load the different files into the drop down list
                      menu.
         */
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFiles();
            }
        }

        /*
        Function: public string[] GetFileList()
        Returns: string array: holds all the files in the given directory
        Description: This will parse through and retrieve each file from the given file path. 
                     Saving it to a string array data structure.
        */
        [WebMethod]
        public string[] GetFileList()
        {
            string[] fileList = Directory.GetFiles(MyFilesPath);

            for (int i = 0; i < fileList.Length; i++)
            {
                fileList[i] = Path.GetFileName(fileList[i]);
            }
            return fileList;
        }

        /*
        Function: public string[] GetFileList()
        Returns: string array: holds all the files in the given directory
        Description: This will load all of the files from the given directory into the drop down list
        */
        public void LoadFiles()
        {
            string[] files = Directory.GetFiles(MyFilesPath);
            FileDropDown.Items.Clear();

            foreach (string document in files) //Appending to the FileDropDown
            {
                FileDropDown.Items.Add(new System.Web.UI.WebControls.ListItem(Path.GetFileName(document), Path.GetFileName(document)));
            }
        }

        /*
        Function: public string GetContent(string name)
        Returns: string
        Description: Receives a name to a file and checks if the file is existent in the given
                     directory. If not existent it returns null, if it exists it reads all of the
                     content in the file and returns it.
        */
        [WebMethod]
        public string GetContent(string name)
        {
            string path = $"{MyFilesPath}/{name}";

            if (!File.Exists(path))
            {
                return null;
            }
            else
            {
                return File.ReadAllText(path);
            }

        }

        /*
        Function: public void openFile_Click(object sender, EventArgs e)
        Returns: void
        Description: When invoked, it will call get content to get the text in a file
                     and display it in the client web text box.
        */
        public void openFile_Click(object sender, EventArgs e)
        {
            var text = GetContent(FileDropDown.SelectedValue);
            textEdit.Text = text;
        }

        /*
        Function: public void SaveFile(object sender, EventArgs e)
        Returns: void
        Description: Will save text that the user has written in the text box into their chosen
                     text file from the drop down menu list. It will not append and will overwrite the
                     file from the start.
        */
        public void SaveFile(object sender, EventArgs e)
        {
            string toSave = textEdit.Text;
            string file = $"{MyFilesPath}/{FileDropDown.SelectedValue}";

            using (System.IO.StreamWriter writer = new System.IO.StreamWriter(file, false))
            {
                writer.WriteLine(toSave);
            }
        }

        /*
        Function: public void SaveAs(object sender, EventArgs e)
        Returns: void
        Description: Will create a new file or overwrite completely given a file name that the user
                     enters. Then writes the contents that the user wrote in the editor text box.
        */
        public void SaveAs(object sender, EventArgs e)
        {
            string toSave = textEdit.Text;
            string newName = saveAsName.Value;
            string path = Path.Combine(MyFilesPath, $"{newName}.txt");

            using (StreamWriter writer = new StreamWriter(path, false))
            {
                writer.WriteLine(toSave);
            }
            LoadFiles();
        }
    }

    
}