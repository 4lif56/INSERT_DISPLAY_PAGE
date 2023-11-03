<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VehicleForm1.aspx.vb" Inherits="WebApplication1.VehicleForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="StyleSheet1.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous" />
    <title>Vehicle Form</title>
    <style type="text/css">
        body {
            background-color: #EFECF8;
        }

        /* Style for the header row */
        .header-row {
            background-color: #B9A5DE; /* Set the background color for the header row */
            font-weight: bold; /* Make the header text bold or customize as needed */
        }

        /* Style for the data rows */
        .table-data {
            background-color: #DDDDDD; /* Set the background color for the data rows */
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
            padding: 7px 15px; /* Reduce padding to make the button smaller */
            border: none; /* Remove default button border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Change cursor to a pointer */
            transition: background-color 0.3s, box-shadow 0.3s; /* Smooth transitions for color and box shadow */
            margin-right: 10px; /* Add right margin for spacing */
        }

            .action-button:hover {
                background-color: #8662D1; /* Lighter color on hover */
            }

            .action-button:active {
                background-color: #4A308B; /* Darker color when clicked */
                box-shadow: 0 0 5px rgba(0, 0, 0, 0.5); /* Add a shadow when clicked */
            }

        input:focus {
            border: 2px solid #000; /* Black border on focus */
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
       <br> <div class="container rounded-block">
     <div class="container">
    <div class="row">
        <div class="col-6">
            <h2>VEHICLE LIST</h2>
        </div>
    </div>
</div>

<div class="container">
    <div class="row">
        <div class="col">
            <asp:Table ID="tblVehicle" runat="server" BackColor="#F6F6F6" BorderColor="Black" BorderWidth="2px" CssClass="table table-bordered" ForeColor="Black" GridLines="Both">
                <asp:TableRow runat="server" CssClass="header-row">
                    <asp:TableCell runat="server">VEHICLE NO</asp:TableCell>
                    <asp:TableCell runat="server">COLOUR</asp:TableCell>
                    <asp:TableCell runat="server">BRAND</asp:TableCell>
                    <asp:TableCell runat="server">MODEL</asp:TableCell>
                     <asp:TableCell runat="server">IMAGE</asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </div>
    </div>
</div>

<div class="container">
    <div class="row justify-content-end">
        <div class="col-12">
            <asp:Button ID="btnPrint" runat="server" Text="Print" OnClientClick="printTable(); return false;" CssClass="action-button" />
           <asp:Button ID="btnDown" runat="server" Text="Download" CssClass="action-button" OnClientClick="downloadTable('tblVehicle'); return false;" />
        </div>
    </div>
</div>
           </div><br>
    <script type="text/javascript">

            function printTable() {
                var printContents = document.getElementById("tblVehicle").outerHTML;
                var originalContents = document.body.innerHTML;
                document.body.innerHTML = printContents;
                window.print();
                document.body.innerHTML = originalContents;

            }
            function printTable() {
                var printContents = document.getElementById("tblVehicle").outerHTML;
                var originalContents = document.body.innerHTML;
                document.body.innerHTML = printContents;
                window.print();
                document.body.innerHTML = originalContents;
            }

            function downloadTable(tableId) {
                // Create a reference to the table element
                var table = document.getElementById(tableId);

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
        

    </script>
        </form>
    </body>
</html>
