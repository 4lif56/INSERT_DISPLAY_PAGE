<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm1.aspx.vb" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="StyleSheet1.css" rel="StyleSheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        function updateButtonText(rowIndex, fileInput) {
            var btnFile = document.getElementById('btnFile_' + rowIndex);
            if (btnFile) {
                btnFile.innerText = fileInput.value.split('\\').pop();
            }
        }

    </script>
    <style type="text/css">
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            border-color: black;
            width: 100%;
            counter-reset: rowNumber;
            counter-reset: tableCount;
        }

        .table td {
            border: 1px solid black;
        }

        .counterCell:before {
            content: counter(tableCount);
            counter-increment: tableCount;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child() {
            background-color: #dddddd;
        }

        #Name0 {
            width: 350px;
        }

        .submit-button {
            background-color: #673AB7; /* Blue background color */
            color: #fff; /* White text color */
            padding: 10px 20px; /* Padding around the button text */
            border: none; /* Remove default button border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Change cursor to a pointer */
            transition: background-color 0.3s, box-shadow 0.3s; /* Smooth transitions for color and box shadow */
            position: relative; /* Create a stacking context for pseudo-elements */
            overflow: hidden; /* Hide overflowing pseudo-elements */
        }

            .submit-button:hover {
                background-color: #8662D1; /* Lighter color on hover */
            }

            .submit-button:active {
                background-color: #4A308B; /* Darker color when clicked */
                box-shadow: 0 0 5px rgba(0, 0, 0, 0.5); /* Add a shadow when clicked */
            }

        input:focus {
            border: 2px solid #000; /* Black border on focus */
        }

        .action1-button {
            background-color: #673AB7; /* Blue background color */
            color: #fff; /* White text color */
            padding: 7px 15px; /* Reduce padding to make the button smaller */
            border: none; /* Remove default button border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Change cursor to a pointer */
            transition: background-color 0.3s, box-shadow 0.3s; /* Smooth transitions for color and box shadow */
            margin-right: 10px; /* Add right margin for spacing */
        }

            .action1-button:hover {
                background-color: #8662D1; /* Lighter color on hover */
            }

            .action1-button:active {
                background-color: #4A308B; /* Darker color when clicked */
                box-shadow: 0 0 5px rgba(0, 0, 0, 0.5); /* Add a shadow when clicked */
            }

        .action2-button {
            background-color: #673AB7; /* Blue background color */
            color: #fff; /* White text color */
            padding: 5px 10px; /* Reduce padding to make the button smaller */
            border: none; /* Remove default button border */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Change cursor to a pointer */
            transition: background-color 0.3s, box-shadow 0.3s; /* Smooth transitions for color and box shadow */
            margin-right: 10px; /* Add right margin for spacing */
        }

            .action2-button:hover {
                background-color: #8662D1; /* Lighter color on hover */
            }

            .action2-button:active {
                background-color: #4A308B; /* Darker color when clicked */
                box-shadow: 0 0 5px rgba(0, 0, 0, 0.5); /* Add a shadow when clicked */
            }

        body {
            background-color: #EFECF8;
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
        /* Normal state styles */

        .table-header {
            background-color: #ABD3F2; /* Set the background color for the header row */
            font-weight: bold; /* Make the header text bold or customize as needed */
        }

        .image-preview {
            max-width: 100px; /* Set the maximum width as needed */
            max-height: 100px; /* Set the maximum height as needed */
            object-fit: contain; /* Maintain aspect ratio while fitting within the specified dimensions */
        }

        .custom-button {
            background-color: white;
            border: none;
            color: #673AB7;
            padding: 7px 15px; /* Adjust padding as needed */
            border-radius: 5px; /* Adds rounded corners */
            cursor: pointer; /* Show pointer cursor on hover */
            transition: background-color 0.3s, color 0.3s, box-shadow 0.3s; /* Add a smooth transition effect */
        }

            .custom-button:hover {
                background-color: #f3f3f3; /* Slightly darker than white on hover */
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
        <input type="file" id="fileUpload" style="display: none;" onchange="updateButtonText(this);" />
        <br>
        <div class="container rounded-block">
              <div class="container">
                <div class="row">
                    <div class="col-6">
                        <h2>USER FORM </h2>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="row">
                    <div class="col-6">
                        <label for="userNo">
                            User Number:
                        </label>
                        <asp:Label ID="lblUserNo" runat="server" Width="25px" Height="40px"></asp:Label>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-6">
                        <label for="name">Personal Name:</label>
                        <br>
                        <asp:TextBox ID="txtName" runat="server" placeholder="Enter your name" CssClass="form-control" Width="500px" Height="40px"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="NameValidator" runat="server"
                            ControlToValidate="txtName"
                            ErrorMessage="Please enter a name."
                            ForeColor="Red"
                            Display="Dynamic"
                            ValidationGroup="Valid">
                        </asp:RequiredFieldValidator>
                    </div>

                    <br>
                    <div class="col-6">
                        <label for="ic">IC No:</label>
                        <br>
                        <asp:TextBox ID="txtIc" runat="server" CssClass="form-control" Width="500px" MaxLength="12" onkeydown="return(!(event.keyCode>=65) && event.keyCode!=32);" placeholder="Enter your IC number" Height="40px"></asp:TextBox>
                        <span class="text-danger">
                            <asp:RegularExpressionValidator ID="RegexValidator" runat="server"
                                ControlToValidate="txtIc"
                                ValidationExpression="^.{12}$"
                                ForeColor="Red"
                                ErrorMessage="IC must be exactly 12 characters."
                                Display="Dynamic" />
                            <asp:RequiredFieldValidator ID="ICValidator" runat="server"
                                ControlToValidate="txtIc"
                                ErrorMessage="Please enter a valid IC Number."
                                Display="Dynamic"
                                InitialValue=""
                                ForeColor="Red"
                                ValidationGroup="Valid">
                            </asp:RequiredFieldValidator>
                        </span>
                    </div>
                </div>

            </div>
            <!-- Name and IC No -->
            <div class="container">
                <div class="row">
                    <div class="col-6">
                        <br>
                        <label for="personDescription">Description of person:</label><br>
                        <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" Width="500px" placeholder="Enter your description" Height="80px" TextMode="MultiLine"></asp:TextBox>
                        <span class="valid-feedback">Looks good!</span>
                        <asp:RequiredFieldValidator ID="DescValidator" runat="server"
                            ControlToValidate="txtDesc"
                            ErrorMessage=""
                            ForeColor="Red"
                            Display="Dynamic"
                            ValidationGroup="Valid">
        Please enter a Description.
                        </asp:RequiredFieldValidator>
                    </div>

                    <div class="col-6">
                        <br>
                        <label for="dateBirth">Date of Birth:</label>
                        <br>
                        <asp:TextBox ID="txtDob" runat="server" CssClass="form-control" Width="500px" placeholder="Choose your birthday" Height="40px" TextMode="Date" AutoPostBack="True" OnTextChanged="DoB_TextChanged"></asp:TextBox>
                        <span class="valid-feedback">Looks good!</span>
                        <asp:RequiredFieldValidator ID="rfvDob" runat="server" ControlToValidate="txtDob"
                            ErrorMessage=""
                            ForeColor="Red"
                            Display="Dynamic"
                            ValidationGroup="Valid">
        Please choose a date.
                        </asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <!-- Description and Birth Date -->
            <div class="container">
                <div class="row">
                    <div class="col">
                        <br>
                        <label for="nationality" class="form-label">
                            Nationality:<br>
                        </label>
                        <br>
                        <asp:DropDownList ID="txtNation" runat="server" CssClass="form-control" Width="500px" Height="40px">
                            <asp:ListItem Selected="True" Value="0">Sila Pilih</asp:ListItem>
                        </asp:DropDownList><br>
                        <span class="valid-feedback">Looks good!</span>
                        <asp:RequiredFieldValidator ID="NationalityValidator" runat="server"
                            ControlToValidate="txtNation"
                            ErrorMessage=""
                            ForeColor="Red"
                            Display="Dynamic"
                            ValidationGroup="Valid">
                Please pick your nationality.
                        </asp:RequiredFieldValidator>
                        <br />
                        <br>
                    </div>

                    <div class="col">
                        <p style="margin-bottom: -8px;">
                            <br>
                            <label for="gender" class="form-label">Gender:</label>
                             <asp:RadioButtonList ID="listGender" runat="server" AutoPostBack="True" RepeatDirection="Horizontal" BackColor="White" BorderColor="Black" Width="270px">
                                <asp:ListItem Value="M"> &nbsp;Male</asp:ListItem>
                                <asp:ListItem Value="F"> &nbsp;Female</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:RequiredFieldValidator ID="GenderValidator" runat="server"
                                ControlToValidate="listGender"
                                ErrorMessage="Please pick your gender."
                                ForeColor="Red"
                                Display="Dynamic"
                                ValidationGroup="Valid"
                                InitialValue=""></asp:RequiredFieldValidator>
                        </p>
                    </div>
                </div>
            </div>
            <!-- Nationality and Gender -->
            <div class="container">
                <div class="row">
                    <div class="col">
                        <label for="date">
                            Today Date:
                        </label>
                        <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" ReadOnly="True" Width="500px" Height="40px"></asp:TextBox>
                        <span class="valid-feedback">Looks good!</span>
                    </div>
                    <div class="col">
                        <label for="age">
                            Current Age:
                        </label>
                        <asp:TextBox ID="txtAge" runat="server" CssClass="form-control" placeholder="No Age" ReadOnly="True"></asp:TextBox>
                        <span class="valid-feedback">Looks good!</span>
                    </div>
                </div>
            </div>
        </div>
        <!-- Today Date and Current Age -->
        <br>
        <div class="container rounded-block">
               <div class="container">
                <div class="row">
                    <div class="col-6">
                        <h2>VEHICLE FORM </h2>
                    </div>
                </div>
            </div>
            <br>
            <div class="container">
                <div class="row">
                    <div class="col-3">
                        <div class="form-group">
                            <label for="name">Vehicle Number:</label>
                            <asp:TextBox ID="txtVnum" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="validVnum" runat="server" ValidationGroup="AddData"
                                ControlToValidate="txtVnum"
                                ErrorMessage="Please type your vehicle number."
                                ForeColor="Red"
                                Display="Dynamic"
                                InitialValue=""></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="form-group">
                            <label for="name">Vehicle Colour:</label>
                            <asp:TextBox ID="txtColour" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="validColour" runat="server" ValidationGroup="AddData"
                                ControlToValidate="txtColour"
                                ErrorMessage="Please type your vehicle colour."
                                ForeColor="Red"
                                Display="Dynamic"
                                InitialValue=""></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="form-group">
                            <label for="name">Vehicle Brand:</label>
                            <asp:TextBox ID="txtBrand" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="validBrand" runat="server" ValidationGroup="AddData"
                                ControlToValidate="txtBrand"
                                ErrorMessage="Please type your vehicle brand."
                                ForeColor="Red"
                                Display="Dynamic"
                                InitialValue=""></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="form-group">
                            <label for="name">Vehicle Model:</label>
                            <asp:TextBox ID="txtModel" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="validModel" runat="server" ValidationGroup="AddData"
                                ControlToValidate="txtModel"
                                ErrorMessage="Please type your vehicle model."
                                ForeColor="Red"
                                Display="Dynamic"
                                InitialValue=""></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col">
                <asp:Button ID="btnAdd" OnClick="btnAdd_Click" runat="server" Text="Add" ValidationGroup="AddData" CssClass="action1-button" CausesValidation="True" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="action1-button" CausesValidation="False" />
                <asp:Button ID="btnUpload" runat="server" Text="Upload File" CssClass="custom-button" OnClientClick="document.getElementById('fileUpload1').click(); return false;" CausesValidation="True" ValidationGroup="UploadData" />
                <asp:FileUpload ID="fileUpload1" Style="display: none;" runat="server" CssClass="custom-file-input" onchange="handleFileUpload(this)" />
                <br>
                <script>
                    function handleFileUpload() {
                        var button = document.getElementById('<%= btnUpload.ClientID %>');
                        var fileInput = document.getElementById('<%= fileUpload1.ClientID %>');

                        if (fileInput.files.length > 0) {
                            var fileName = fileInput.files[0].name;
                            button.classList.remove("custom-button");
                            button.classList.add("action-button");
                            button.value = fileName;
                        } else {
                            button.classList.remove("action-button");
                            button.classList.add("custom-button");
                            button.value = "Upload File";
                        }
                    }
                </script>
                <br>
            </div>

            <asp:Table ID="tblVehicle" runat="server" BackColor="#F6F6F6" BorderColor="Black" BorderWidth="2px" CssClass="table table-bordered" ForeColor="Black" GridLines="Both">
                <asp:TableHeaderRow runat="server" CssClass="header-row" BackColor="#B9A5DE">
                    <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Vehicle No</span>
                    </asp:TableHeaderCell>
                    <asp:TableHeaderCell runat="server" Style="display: none;">
            <span style="text-transform: uppercase; font-weight: bold;">Colour</span>
                    </asp:TableHeaderCell>
                    <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Brand</span>
                    </asp:TableHeaderCell>
                    <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Model</span>
                    </asp:TableHeaderCell>
                    <asp:TableHeaderCell runat="server">
            <span style="text-transform: uppercase; font-weight: bold;">Action</span>
                    </asp:TableHeaderCell>
                </asp:TableHeaderRow>
            </asp:Table>


        </div>
        <br>
        <!-- Table for Vehicle -->
        <div class="container">
            <div class="row">
                <div class="col">
                    <asp:Button ID="submit" runat="server" Text="Submit" OnClick="Submit_Click" ValidationGroup="Valid" CssClass="submit-button" />
                </div>
            </div>
        </div>
        <!-- Submit Button -->
        <div class="container">
            <div class="row">
                <div class="col">
                    <asp:Label ID="SuccessLabel" runat="server" ForeColor="Green" Display="Dynamic"></asp:Label>
                    <asp:Label ID="ErrorLabel" runat="server" ForeColor="Red" Display="Dynamic"></asp:Label>
                </div>
            </div>
        </div>
        <br>
        <!-- Success or error label -->
    </form>

</body>
</html>
