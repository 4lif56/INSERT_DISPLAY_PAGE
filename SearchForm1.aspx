<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="SearchForm1.aspx.vb" Inherits="WebApplication1.SearchForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="StyleSheet1.css" rel="StyleSheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <title></title>
    <style type="text/css">
        body {
            background-color: #EFECF8;
        }

        /* Add a background color to rows when hovered */
        #tblInfo tr:hover {
            background-color: #f5f5f5; /* Change this to your desired hover color */
            cursor: pointer; /* Change the cursor style to indicate interactivity */
        }

            /* Optionally, you can change the text color when hovered */
            #tblInfo tr:hover td {
                color: #333; /* Change this to your desired text color */
            }

        /* Style for the data rows */
        .table-data {
            background-color: #DDDDDD; /* Set the background color for the data rows */
        }
        /* Target the third th (table header) in the thead element */

        .auto-style1 {
            width: 370px;
        }

        .rounded-block {
            border: 2px solid black; /* Border color and thickness */
            border-top: 7px solid #563D7C; /* Solid color line at the top */
            border-radius: 10px; /* Rounded corners */
            padding: 20px; /* Spacing inside the block */
            background-color: white; /* Background color of the block */
        }

            /* Style for headings inside the block */
            .rounded-block h2 {
                margin-top: 0; /* Remove top margin for headings */
            }

            /* Style for labels inside the block */
            .rounded-block label {
                font-weight: bold; /* Make labels bold */
            }

        .action-button {
            background-color: #673AB7; /* Blue background color */
            color: #fff; /* White text color */
            padding: 5px 10px; /* Reduce padding to make the button smaller */
            border: none; /* Remove default button border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Change cursor to a pointer */
            width: 100%;
            margin: 10px;
        }

            .action-button:hover {
                background-color: #8662D1; /* Lighter color on hover */
            }

            .action-button:active {
                background-color: #4A308B; /* Darker color when clicked */
            }

        input:focus {
            border: 2px solid #000; /* Black border on focus */
        }

        .action-button:disabled {
            /* Add styles for disabled buttons here */
            opacity: 0.5; /* Example: Reducing opacity when disabled */
            cursor: not-allowed; /* Example: Change cursor to 'not-allowed' */
        }

        .navbar-light .navbar-nav .nav-link {
            color: white; /* Set the default color for the links */
            transition: color 0.3s; /* Add a smooth transition effect for color change */
        }

            .navbar-light .navbar-nav .nav-link:hover {
                color: #ffffff80; /* Change 'yourDesiredColor' to your preferred color */
            }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light" style="background-color: #5D45AA;">
        <div class="container">
            <a class="navbar-brand mb-0 h1" href="WebForm1.aspx" style="font-size: 24px; font-weight: bold; color: white;">MY FORM</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="WebForm1.aspx">Create</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="SearchForm1.aspx">Search</a>
                    </li>
                    <!-- Add more navigation links as needed -->
                </ul>
            </div>
        </div>
    </nav>
    <form id="form1" runat="server">
        <br>
        <div class="container rounded-block">
            <div class="container">
                <div class="row">
                    <div class="col-6">
                        <h2>SEARCH FORM </h2>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="row">
                    <asp:HiddenField ID="hdnDeleteRowIndex" runat="server" />
                    <div class="col">
                        <label for="name">Name: </label>
                        <br />
                        <asp:TextBox ID="txtFilter" runat="server" placeholder="Filter by name" class="auto-style1"></asp:TextBox>
                    </div>
                    <div class="col">
                        <p style="margin-bottom: -8px;">
                            <label for="gender" class="form-label">Gender:</label>
                            <asp:RadioButtonList ID="listGender" runat="server" AutoPostBack="True" RepeatDirection="Horizontal" BackColor="White" BorderColor="Black" Width="270px" CssClass="gender-filter">
                               <asp:ListItem Value="All"> &nbsp;All</asp:ListItem>
                                <asp:ListItem Value="M"> &nbsp;Male</asp:ListItem>
                                <asp:ListItem Value="F"> &nbsp;Female</asp:ListItem>
                            </asp:RadioButtonList>
                        </p>
                    </div>
                </div>
                </div>
                <div class="row">
                    <div class="row justify-content-between">
                        <div class="col">
                            <asp:Button ID="btnPrint" runat="server" Text="Print" OnClientClick="printTable(); return false;" CssClass="action-button" />
                        </div>
                        <div class="col">
                            <asp:Button ID="btnDownload" runat="server" Text="Download" OnClientClick="downloadTable();" CssClass="action-button" />
                        </div>                  
                        <div class="col">
                            <asp:Button ID="btnEdit" runat="server" Text="Edit" OnClientClick="handleEditClick();" Enabled="true" OnClick="btnEdit_Click" CssClass="action-button" />
                        </div>
                        <div class="col">
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClientClick="handleDeleteClick();" Enabled="true" OnClick="btnDelete_Click" CssClass="action-button" />
                        </div>
                    </div>

                </div>
                <br />
                <asp:Table ID="tblInfo" runat="server" BackColor="#F6F6F6" BorderColor="Black" BorderWidth="2px" CssClass="table table-bordered" ForeColor="Black" GridLines="Both">
                    <asp:TableHeaderRow runat="server" CssClass="header-row" BackColor="#B9A5DE">
                        <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">No</span>
                        </asp:TableHeaderCell>
                        <asp:TableHeaderCell runat="server" Style="display: none;">
            <span style="text-transform: uppercase; font-weight: bold;">UserNo</span>
                        </asp:TableHeaderCell>
                        <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Name</span>
                        </asp:TableHeaderCell>
                        <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">IC</span>
                        </asp:TableHeaderCell>
                        <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Description</span>
                        </asp:TableHeaderCell>
                        <asp:TableHeaderCell runat="server" Width="135px">
            <span style="text-transform: uppercase; font-weight: bold;">Date of Birth</span>
                        </asp:TableHeaderCell>
                        <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Nationality</span>
                        </asp:TableHeaderCell>
                        <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Gender</span>
                        </asp:TableHeaderCell>
                        <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Age</span>
                        </asp:TableHeaderCell>
                    </asp:TableHeaderRow>
                </asp:Table>
            </div>
        </div>
        <br>

        <script type="text/javascript">
            function printTable() {
                var printContents = document.getElementById('<%= tblInfo.ClientID %>').outerHTML;
                var originalContents = document.body.innerHTML;
                document.body.innerHTML = printContents;
                window.print();
                document.body.innerHTML = originalContents;
                attachRowClickEventListeners(); // Reattach event listeners after printing
            }

            // Attach event listeners to table rows
            function attachRowClickEventListeners() {
                var tableRows = document.querySelectorAll("#tblInfo tr");
                for (var i = 1; i < tableRows.length; i++) { // Start from index 1 to skip the header row
                    tableRows[i].addEventListener("click", function () {
                        redirectToEditPage(this);
                    });
                }
            }

            function downloadTable() {
                // Create a reference to the table element
                var table = document.getElementById('<%= tblInfo.ClientID %>');

                // Clone the table to maintain its original styling
                var clonedTable = table.cloneNode(true);

                // Add the same CSS classes to the cloned table as in the original table
                clonedTable.className = table.className;

                // Apply additional styles to the cloned table
                clonedTable.style.backgroundColor = '#DDDDDD'; // Background color for data rows
                clonedTable.style.borderCollapse = 'collapse'; // Table border collapse
                clonedTable.style.border = '2px solid black'; // Table border
                clonedTable.style.width = '100%'; // Adjust the width as needed
                // You can add more styles as needed

                // Apply styles to table cells
                var tableCells = clonedTable.getElementsByTagName('td');
                for (var i = 0; i < tableCells.length; i++) {
                    tableCells[i].style.padding = '8px'; // Adjust padding as needed
                    // You can add more cell styles here
                }

                // Apply styles to header cells (first row)
                var headerCells = clonedTable.rows[0].cells; // Select the first row cells
                for (var i = 0; i < headerCells.length; i++) {
                    headerCells[i].style.backgroundColor = '#B9A5DE'; // Background color for the top row
                    headerCells[i].style.fontWeight = 'bold'; // Make the top row text bold
                    // You can add more top row cell styles here
                }

                // Create a new Blob object containing the cloned table's HTML
                var blob = new Blob([clonedTable.outerHTML], { type: 'text/html' });

                // Create a temporary <a> element and set its attributes
                var a = document.createElement('a');
                a.href = window.URL.createObjectURL(blob);
                a.download = 'table.html';

                // Simulate a click on the <a> element to trigger the download
                a.style.display = 'none';
                document.body.appendChild(a);
                a.click();

                // Clean up
                document.body.removeChild(a);
            }

            document.addEventListener("DOMContentLoaded", function () {
                var tableRows = document.querySelectorAll("#tblInfo tr");
                for (var i = 1; i < tableRows.length; i++) { // Start from index 1 to skip the header row
                    tableRows[i].addEventListener("click", function () {
                        redirectToEditPage(this);
                    });
                }
            });

            var lastClickedUserNo = null;
            function redirectToEditPage(clickedRow) {
                // Check if the "Edit" button is enabled
                var editButton = document.getElementById('<%= btnEdit.ClientID %>');
                var deleteButton = document.getElementById('<%= btnDelete.ClientID %>');
                var table = document.getElementById('<%= tblInfo.ClientID %>');

                if (!deleteButton.disabled && !editButton.disabled) {
                    // Get the UserNo from the clicked row (assuming it's in the second cell)
                    var userNo = clickedRow.cells[1].textContent;

                    // Store the last clicked userNo in the global variable
                    lastClickedUserNo = userNo;

                    // Construct the URL with query parameters for VehicleForm1
                    var editUrl = "VehicleForm1.aspx" +
                        "?userNo=" + encodeURIComponent(userNo) +
                        "&displayVehicleData=true"; // Indicate that you want to display vehicle data

                    // Redirect to VehicleForm1 with query parameters
                    window.location.href = editUrl;

                } else if (editButton.disabled && !deleteButton.disabled) {
                    // Redirect to WebForm1 when the "Edit" button is disabled
                    var no = clickedRow.cells[0];
                    var userNo = clickedRow.cells[1].textContent;
                    var name = clickedRow.cells[2].textContent;
                    var ic = clickedRow.cells[3].textContent;
                    var description = clickedRow.cells[4].textContent;
                    var dob = clickedRow.cells[5].textContent;
                    var nationality = clickedRow.cells[6].textContent;
                    var gender = clickedRow.cells[7].textContent;
                    var age = clickedRow.cells[8].textContent;


                    // Construct the URL with query parameters for WebForm1
                    var editUrl = "WebForm1.aspx" +
                        "?userNo=" + encodeURIComponent(userNo) +
                        "&name=" + encodeURIComponent(name) +
                        "&ic=" + encodeURIComponent(ic) +
                        "&description=" + encodeURIComponent(description) +
                        "&dob=" + encodeURIComponent(dob) +
                        "&nationality=" + encodeURIComponent(nationality) +
                        "&gender=" + encodeURIComponent(gender) +
                        "&age=" + encodeURIComponent(age);

                    // Redirect to WebForm1 with query parameters
                    window.location.href = editUrl;

                } else if (!editButton.disabled && deleteButton.disabled) {
                    // Delete button is disabled, delete the row and corresponding data
                    console.log("Delete button clicked");
                    var userNo = clickedRow.cells[1].textContent;
                    console.log("UserNo to delete: " + userNo);

                    // Trigger a postback to execute the server-side delete method
                    __doPostBack("DeleteRowAndData", userNo);
                }

            }

            var editButtonClicked = false;

            function handleEditClick() {
                // Disable the "Edit" button when clicked
                document.getElementById('<%= btnEdit.ClientID %>').disabled = true;
                editButtonClicked = true;
            }

            // Add a click event listener to the document body to enable the button on any click
            document.body.addEventListener("click", function (event) {
                if (editButtonClicked && event.target !== document.getElementById('<%= btnEdit.ClientID %>')) {
                    // Enable the "Edit" button only if it was clicked previously and the click didn't target the button itself
                    document.getElementById('<%= btnEdit.ClientID %>').disabled = false;
                    editButtonClicked = false; // Reset the flag
                }
            });

            var deleteButtonClicked = false;

            function handleDeleteClick() {
                // Disable the "Delete" button when clicked
                document.getElementById('<%= btnDelete.ClientID %>').disabled = true;
                deleteButtonClicked = true;
                return false;
            }

            // Add a click event listener to the document body to enable the button on any click
            document.body.addEventListener("click", function (event) {
                if (deleteButtonClicked && event.target !== document.getElementById('<%= btnDelete.ClientID %>')) {
                    // Enable the "Delete" button only if it was clicked previously and the click didn't target the button itself
                    document.getElementById('<%= btnDelete.ClientID %>').disabled = false;
                    deleteButtonClicked = false; // Reset the flag
                }
            });

            $(document).ready(function () {
                var timeout;
                var nameFilter = "";
                var genderFilter = "All";

                $("#txtFilter").on("input", function () {
                    clearTimeout(timeout);
                    nameFilter = $(this).val().trim().toLowerCase();
                    filterData();
                });

                $(".gender-filter input[type=radio]").on("change", function () {
                    genderFilter = $(this).val();
                    filterData();
                });

                function filterData() {
                    $("#tblInfo tbody tr").each(function (index) {
                        if (index === 0) {
                            return;
                        }

                        var name = $(this).find("td:nth-child(3)").text().toLowerCase();
                        var gender = $(this).find("td:nth-child(8)").text().toLowerCase();

                        var nameMatch = name.includes(nameFilter);
                        var genderMatch = genderFilter === "All" || gender === genderFilter;

                        if (nameMatch && genderMatch) {
                            $(this).show();
                        } else {
                            $(this).hide();
                        }
                    });
                }
            });

            $(document).ready(function () {
                var timeout;
                var nameFilter = "";
                var genderFilter = "All";

                $("#txtFilter").on("input", function () {
                    clearTimeout(timeout);
                    nameFilter = $(this).val().trim().toLowerCase();
                    timeout = setTimeout(filterData, 300);
                });

                $(".gender-filter input[type=radio]").on("change", function () {
                    genderFilter = $(this).val();
                    filterData();
                });

                function filterData() {
                    $("#tblInfo tbody tr").each(function (index) {
                        if (index === 0) {
                            return;
                        }

                        var name = $(this).find("td:nth-child(3)").text().toLowerCase();
                        var gender = $(this).find("td:nth-child(8)").text().toLowerCase();

                        var nameMatch = name.includes(nameFilter);
                        var genderMatch = genderFilter === "All" || gender === genderFilter;

                        if (nameMatch && genderMatch) {
                            $(this).show();
                        } else {
                            $(this).hide();
                        }
                    });
                }
            });

            $(document).ready(function () {
                // Get references to the radio buttons and all table rows
                var maleRadioButton = $("input[name*='listGender'][value='M']");
                var femaleRadioButton = $("input[name*='listGender'][value='F']");
                var allRadioButton = $("input[name*='listGender'][value='All']");
                var tableRows = $("#tblInfo tr");

                // Function to hide unchecked gender rows
                function hideUncheckedGenderRows() {
                    tableRows.show(); // Show all rows initially
                    if (!allRadioButton.is(":checked")) {
                        if (!maleRadioButton.is(":checked")) {
                            tableRows.filter(".male").hide();
                        }
                        if (!femaleRadioButton.is(":checked")) {
                            tableRows.filter(".female").hide();
                        }
                    }
                }

                // Add a change event listener to the radio buttons
                maleRadioButton.change(function () {
                    hideUncheckedGenderRows();
                });

                femaleRadioButton.change(function () {
                    hideUncheckedGenderRows();
                });

                allRadioButton.change(function () {
                    hideUncheckedGenderRows();
                });

                // Initially, hide unchecked gender rows when the page loads
                hideUncheckedGenderRows();
            });

            // JavaScript code to add hover effect to dynamically generated rows
            document.addEventListener("DOMContentLoaded", function () {
                var tableRows = document.querySelectorAll("#tblInfo tr");

                for (var i = 1; i < tableRows.length; i++) { // Start from index 1 to skip the header row
                    tableRows[i].addEventListener("mouseover", function () {
                        this.style.backgroundColor = "#CCCCCC"; // Change this to your desired hover color
                        this.style.cursor = "pointer"; // Change the cursor style to indicate interactivity
                    });

                    tableRows[i].addEventListener("mouseout", function () {
                        this.style.backgroundColor = ""; // Reset the background color on mouseout
                    });
                }
            });

            document.addEventListener("DOMContentLoaded", function () {
                // Get references to the gender dropdown and search input elements
                var genderDropdown = document.getElementById("listGender");
                var searchInput = document.getElementById("txtFilter");

                // Add an event listener to the gender dropdown
                genderDropdown.addEventListener("change", function () {
                    // Call a function to update the table based on the selected gender and search input
                    updateTable();
                });

                // Add an event listener to the search input
                searchInput.addEventListener("input", function () {
                    // Call a function to update the table based on the selected gender and search input
                    updateTable();
                });

                // Function to update the table
                function updateTable() {
                    var gender = genderDropdown.value;
                    var searchQuery = searchInput.value;

                    // You can choose to make an AJAX request to the server here
                    // and fetch the filtered data, or you can manipulate the table directly on the client-side.
                    // The choice depends on your requirements and architecture.

                    // For client-side table manipulation, you can iterate through the rows and hide/show based on the filters.
                }


            });

            // Add a click event listener to the document body to enable the button on any click
            document.body.addEventListener("click", function (event) {
                if (editButtonClicked && event.target !== document.getElementById('<%= btnEdit.ClientID %>')) {
                // Enable the "Edit" button only if it was clicked previously and the click didn't target the button itself
                document.getElementById('<%= btnEdit.ClientID %>').disabled = false;
                editButtonClicked = false; // Reset the flag
            }
        });
    

        </script>
    </form>
</body>
</html>
