/// <summary>
    /// Method builds up specially formatted query that CIS expects, sends values via webclient upload.
    /// CIS returns with up-to-date class item details in long HTML formatted string.
    /// String is passed to hidden div, div unhidden and displayed as popup extender in page with HTML 
    /// string rendered within popup.
    /// 
    /// Only the item number is passed to cisPOST, everything else is pulled from drop down list states
    /// </summary>
    /// <param name="itemNum">Class item number</param>
    protected void cisPOST(string itemNum)
        {
        
        string uri = "http://www.ctc.edu/cgi-bin/rq010";// CIS cgi path, last three digits represent the col code
        string item = itemNum;
        
        // Do some string operations to parse out values
        string quarter = Request.QueryString["qrtr"].ToUpper();
        string subquarter = quarter.Substring(9, quarter.Length - 9);
        string year = quarter.Substring(0, 9);

        string beginningYear = year.Substring(0,4); // Grab "2009" out of 2009-2010, [2009]-2010
        string endYear = year.Substring(7, 2); // Grab "10" out of 2009-2010, 2009-20[10]


        year = beginningYear + " - " + endYear;// year = "2009 - 10" 
        
        // Each quarter has a number associated that CIS expects, determine quarter
        // then rebuild string in the format CIS cgi is expecting
        switch (subquarter)
            {
            case "SUMMER":
                quarter = "1 - Summer";
                break;
            case "FALL":
                quarter = "2 - Fall";
                break;
            case "WINTER":
                quarter = "3 - Winter";
                break;
            case "SPRING":
                quarter = "4 - Spring";
                break;
            }



        // Create new webclient
        WebClient client = new WebClient();

        // Build post parameters to be sent in HTTP POST
        System.Collections.Specialized.NameValueCollection myForm = new System.Collections.Specialized.NameValueCollection();
        myForm.Add("returnurl", "?");
        myForm.Add("request", "classchd");
        myForm.Add("ayr", year);
        myForm.Add("sess", quarter);
        myForm.Add("item", item);

        // Send POST to CIS
        byte[] cis = client.UploadValues(uri, myForm);

        // Capture response
        string cisReturn = System.Text.Encoding.ASCII.GetString(cis);

        // Remove "Return to Main Menu" and FONT tags from response using some simple RegEx
        string pnlText = Regex.Replace(cisReturn, "(</?(?:u|i|b|a\\s+href=\"[^\">]*\"|(?<=/)a)>)|(<font)[^<]*|(Return To Main Menu)", "");

        // Assign new text to hidden panel/popup
        lblPanel.Text = pnlText;

        // Show that badboy!
        ModalPopupExtender1.Show();
        }
