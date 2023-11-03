Imports System.Data.SqlClient
Imports System.Threading
Imports System.Web.Services.Description
Imports System.Net
Imports Newtonsoft.Json.Linq
Imports System.IO


Public Class WebForm1
    Inherits System.Web.UI.Page
    Dim connectionString As String = "Your Connection String Name"
    Private vehicleDt As DataTable

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Set the max attribute for txtDob
        txtDob.Attributes("max") = DateTime.Now.ToString("yyyy-MM-dd")

        ' Set the text of txtDate to the current date
        txtDate.Text = DateTime.Now.ToString("dd-MM-yyyy")

        If Not IsPostBack Then
            ' Bind the Nationality dropdown from the reference table
            BindNationalityDropdown()

            ' Retrieve query parameters
            Dim name As String = Request.QueryString("name")
            Dim ic As String = Request.QueryString("ic")
            Dim description As String = Request.QueryString("description")
            Dim dob As String = Request.QueryString("dob")
            Dim nationality As String = Request.QueryString("nationality")
            Dim gender As String = Request.QueryString("gender")
            Dim age As String = Request.QueryString("age")
            Dim vehicleNo As String = Request.QueryString("vehicleNo")
            Dim colour As String = Request.QueryString("colour")
            Dim brand As String = Request.QueryString("brand")
            Dim model As String = Request.QueryString("model")
            Dim imageURL As String = Request.QueryString("imageURL")
            Dim userNo As String = Request.QueryString("userNo") ' Add this line to retrieve UserNo

            If Not String.IsNullOrEmpty(userNo) Then
                ' Populate the tblVehicle with data based on the userNo
                PopulateVehicleData(userNo)
            End If

            ' Populate TextBox controls with query parameter values
            txtName.Text = name
            txtIc.Text = ic
            txtDesc.Text = description
            txtDob.Text = dob
            txtNation.SelectedValue = nationality

            ' Set the value of the txtUserNo Label with UserNo
            lblUserNo.Text = userNo ' Use lblUserNo instead of txtUserNo

            ' Find and select the ListItem in the RadioButtonList
            Dim selectedGenderItem As ListItem = listGender.Items.FindByValue(gender)
            If selectedGenderItem IsNot Nothing Then
                selectedGenderItem.Selected = True
            End If

            txtAge.Text = age
            txtVnum.Text = vehicleNo
            txtColour.Text = colour
            txtBrand.Text = brand
            txtModel.Text = model
            btnUpload.Text = "Add File"

            ' Create a DataTable with columns for vehicle data, including the Image column
            Dim dataTable As New DataTable()
            dataTable.Columns.Add("VehicleNo", GetType(String))
            dataTable.Columns.Add("Colour", GetType(String))
            dataTable.Columns.Add("Brand", GetType(String))
            dataTable.Columns.Add("Model", GetType(String))
            dataTable.Columns.Add("ImageURL", GetType(String)) ' Add the Image column

            ' Store the DataTable in the session variable
            Session("VehicleData") = dataTable

            ' Initialize the class-level vehicleDt with the DataTable
            vehicleDt = dataTable

            ' Bind the DataTable to the ASP.NET table control
            BindDataToTable(dataTable)

            ' Check if the query parameter "userNo" is present in the URL
            If Request.QueryString("userNo") IsNot Nothing Then
                ' Fetch vehicle data for the user
                Dim vehicleData As DataTable = GetVehicleData(userNo)
                Session("VehicleData") = vehicleData
                ' Bind the vehicle data to the table in VehicleForm1
                BindDataToTable(vehicleData)
            Else
                ' Handle the case where the "userNo" query parameter is missing
                ' You can display a message or take appropriate action
            End If
        Else
            ' When it's a postback, retrieve the DataTable from the session variable
            Dim dt As DataTable = CType(Session("VehicleData"), DataTable)
            vehicleDt = dt
            BindDataToTable(dt)
        End If
    End Sub

    Private Sub PopulateVehicleData(ByVal userNo As String)
        ' Define your database connection string
        Dim connectionString As String = "Your Connection String Name"

        ' Create a SQL query to fetch the vehicle data for the specified userNo
        Dim query As String = "SELECT VehicleNo, Colour, Brand, Model, ImageURL FROM VehicleForm WHERE UserNo = @UserNo"

        ' Create a SqlConnection and a SqlCommand
        Using connection As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, connection)
                cmd.Parameters.AddWithValue("@UserNo", userNo)

                Try
                    ' Open the database connection
                    connection.Open()

                    ' Execute the SQL query and retrieve the data
                    Dim reader As SqlDataReader = cmd.ExecuteReader()

                    ' Close the reader
                    reader.Close()
                Catch ex As Exception
                    ' Handle any exceptions that may occur during SQL query execution
                    ' For debugging, you can print or log the exception details
                    Response.Write("Error: " & ex.Message)
                Finally
                    ' Ensure the database connection is closed
                    connection.Close()
                End Try
            End Using
        End Using
    End Sub

    Protected Sub Submit_Click(sender As Object, e As EventArgs) Handles submit.Click
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                ' Check if a user with the same UserNo exists in tblInfo
                Dim userNo As Integer = GetUserNoFromTableForm(lblUserNo.Text, connection)

                '' Validate the txtName TextBox
                'If String.IsNullOrWhiteSpace(txtName.Text) Then
                '    ' Name is empty, mark it as invalid
                '    txtName.CssClass = "form-control is-invalid"
                '    NameValidator.ErrorMessage = "Please enter a name."
                '    NameValidator.IsValid = False
                'Else
                '    ' Name is not empty, mark it as valid
                '    txtName.CssClass = "form-control is-valid"
                '    NameValidator.IsValid = True
                'End If

                ' After updating the TableForm, call the function to insert or update the VehicleForm
                If userNo <> -1 Then
                    ' User exists, update the TableForm
                    UpdateTableForm(userNo, connection)
                    UpdateVehicleForm(userNo, connection, vehicleDt)

                    ' Clear the input fields and success/error labels
                    ClearFormFields()
                    SuccessLabel.Text = "Data updated successfully!"
                    ErrorLabel.Text = ""
                Else
                    ' User is new, insert into both TableForm and VehicleForm
                    userNo = InsertTableForm(connection)
                    InsertVehicleForm(userNo, connection, vehicleDt)

                    ' Clear the input fields and success/error labels
                    ClearFormFields()
                    SuccessLabel.Text = "Data inserted successfully!"
                    ErrorLabel.Text = ""
                End If

                '' Reset the TextBox's CSS class to "form-control" if it's not empty
                'If Not String.IsNullOrWhiteSpace(txtName.Text) Then
                '    txtName.CssClass = "form-control"
                'End If

            End Using
        Catch ex As Exception
            ' Handle any exceptions that may occur
            ErrorLabel.Text = "Error: " & ex.Message

            ' Add Bootstrap classes for validation
            txtName.CssClass = "form-control is-invalid"

            SuccessLabel.Text = ""
        End Try
    End Sub

    Private Function GetUserNoFromTableForm(userno As String, connection As SqlConnection) As Integer
        Dim userid As Integer = -1
        Dim selectQuery As String = "SELECT UserNo FROM TableForm WHERE UserNo = @UserNo"

        Using cmdSelect As New SqlCommand(selectQuery, connection)
            cmdSelect.Parameters.AddWithValue("@UserNo", userno)
            Dim result As Object = cmdSelect.ExecuteScalar()

            If result IsNot Nothing AndAlso Not DBNull.Value.Equals(result) Then
                userid = Convert.ToInt32(result)
            End If
        End Using

        Return userId
    End Function


Protected Sub DoB_TextChanged(sender As Object, e As EventArgs) Handles txtDob.TextChanged
        Dim selectDob As DateTime = Date.Parse(txtDob.Text)
        txtAge.Text = calculateAge(selectDob).ToString()
    End Sub

    Private Function CalculateAge(dob As Date) As Integer
        Dim age As Integer = Today.Year - dob.Year

        If dob > Today.AddYears(-age) Then
            age -= 1
        End If

        Return age
    End Function


    Protected Sub CurAge_TextChanged(sender As Object, e As EventArgs)

    End Sub

    Private Sub BindDataToTable(dataTable As DataTable)
        ' Bind the DataTable to the ASP.NET table control
        tblVehicle.Rows.Clear() ' Clear existing rows

        ' Create a header row
        Dim headerRow As New TableRow()
        Dim cellVnum As New TableCell()
        cellVnum.Text = "VEHICLE NO"
        cellVnum.Font.Bold = True
        headerRow.Cells.Add(cellVnum)

        Dim cellColour As New TableCell()
        cellColour.Text = "COLOUR"
        cellColour.Font.Bold = True
        headerRow.Cells.Add(cellColour)

        Dim cellBrand As New TableCell()
        cellBrand.Text = "BRAND"
        cellBrand.Font.Bold = True
        headerRow.Cells.Add(cellBrand)

        Dim cellModel As New TableCell()
        cellModel.Text = "MODEL"
        cellModel.Font.Bold = True
        headerRow.Cells.Add(cellModel)

        ' Create a cell for the image in the header row
        Dim cellImage As New TableCell()
        cellImage.Text = "IMAGE"
        cellImage.Font.Bold = True
        headerRow.Cells.Add(cellImage)

        Dim cellAction As New TableCell()
        cellAction.Text = "ACTION"
        cellAction.Font.Bold = True
        cellAction.Style("width") = "200px"
        headerRow.Cells.Add(cellAction)

        headerRow.BackColor = Drawing.ColorTranslator.FromHtml("#B9A5DE")
        tblVehicle.Rows.Add(headerRow)

        If dataTable.Rows.Count > 0 Then
            ' Create data rows
            For Each row As DataRow In dataTable.Rows
                Dim dataRow As New TableRow()
                dataRow.Cells.Add(New TableCell() With {.Text = row("VehicleNo").ToString()})
                dataRow.Cells.Add(New TableCell() With {.Text = row("Colour").ToString()})
                dataRow.Cells.Add(New TableCell() With {.Text = row("Brand").ToString()})
                dataRow.Cells.Add(New TableCell() With {.Text = row("Model").ToString()})

                ' Create a cell for the image in the data row
                Dim imageCell As New TableCell()
                Dim rowIndex As Integer = dataTable.Rows.IndexOf(row)

                ' Check if an image file was uploaded
                Dim imageFileName As String = row("ImageURL").ToString()
                If Not String.IsNullOrEmpty(imageFileName) Then
                    ' Create an <img> tag to display the image
                    Dim imgTag As New HtmlGenericControl("img")
                    imgTag.Attributes("src") = "Uploads/" & imageFileName ' Update the path to your image folder
                    imgTag.Attributes("alt") = "Image"
                    imgTag.Attributes("class") = "image-preview" ' Add a CSS class for styling

                    ' Add the <img> tag to the cell
                    imageCell.Controls.Add(imgTag)
                End If

                ' Add the image cell to the data row
                dataRow.Cells.Add(imageCell)

                ' Create a cell for buttons (Delete and Update)
                Dim actionCell As New TableCell()

                ' Create the Delete button
                Dim btnDelete As New Button()
                btnDelete.Text = "Delete"
                btnDelete.CssClass = "action2-button"
                btnDelete.CausesValidation = False
                btnDelete.CommandArgument = rowIndex.ToString()
                btnDelete.ValidationGroup = ""
                btnDelete.ID = "btnDelete_" & rowIndex ' Assign a unique ID
                AddHandler btnDelete.Click, AddressOf btnDelete_Click
                actionCell.Controls.Add(btnDelete)

                ' Create the Update button
                Dim btnUpdate As New Button()
                btnUpdate.Text = "Update"
                btnUpdate.CssClass = "action2-button"
                btnUpdate.CausesValidation = False
                btnUpdate.CommandArgument = rowIndex.ToString()
                btnUpdate.ValidationGroup = ""
                btnUpdate.ID = "btnUpdate_" & rowIndex ' Assign a unique ID
                AddHandler btnUpdate.Click, AddressOf btnUpdate_Click
                actionCell.Controls.Add(btnUpdate)

                ' Add the action cell to the row
                dataRow.Cells.Add(actionCell)

                ' Add the data row to the table
                tblVehicle.Rows.Add(dataRow)
            Next
        Else
            ' If no data, leave the table empty
            Dim noDataRow As New TableRow()
            Dim noDataCell As New TableCell()
            noDataCell.ColumnSpan = 6 ' Span across all columns including the action column
            noDataRow.Cells.Add(noDataCell)
            tblVehicle.Rows.Add(noDataRow)
        End If
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs) Handles btnAdd.Click, validBrand.DataBinding, validColour.DataBinding, validVnum.DataBinding, validModel.DataBinding
        ' Retrieve the DataTable from the session
        Dim dataTable As DataTable = CType(Session("VehicleData"), DataTable)

        ' Check if there's an edited row
        Dim editedRowIndex As Integer = -1
        If Session("EditedRowIndex") IsNot Nothing AndAlso Integer.TryParse(Session("EditedRowIndex").ToString(), editedRowIndex) Then
            ' Use the parsed value of editedRowIndex
        Else
            ' Handle the case where Session("EditedRowIndex") is null or not a valid integer
        End If

        ' Get the file name of the uploaded image
        Dim uploadedImageFileName As String = ""
        If fileUpload1.HasFile Then
            uploadedImageFileName = Path.GetFileName(fileUpload1.FileName)

            ' Save the uploaded image to a folder on the server
            Dim imageFilePath As String = Server.MapPath("~/Uploads/") & uploadedImageFileName
            fileUpload1.SaveAs(imageFilePath)
        End If

        If editedRowIndex >= 0 AndAlso editedRowIndex < dataTable.Rows.Count Then
            ' Update the data in the edited row
            Dim editedRow As DataRow = dataTable.Rows(editedRowIndex)
            editedRow("VehicleNo") = txtVnum.Text
            editedRow("Colour") = txtColour.Text
            editedRow("Brand") = txtBrand.Text
            editedRow("Model") = txtModel.Text
            editedRow("ImageURL") = uploadedImageFileName ' Set the image file name

            ' Clear the edited row information
            Session.Remove("EditedRowIndex")
        Else
            ' Check if a row with the same data already exists
            Dim vehicleNo As String = txtVnum.Text
            Dim color As String = txtColour.Text
            Dim brand As String = txtBrand.Text
            Dim model As String = txtModel.Text
            Dim imageURL As String = btnUpload.Text

            Dim matchingRow As DataRow = Nothing

            For Each row As DataRow In dataTable.Rows
                If row("VehicleNo").ToString() = vehicleNo AndAlso
               row("Colour").ToString() = color AndAlso
               row("Brand").ToString() = brand AndAlso
               row("Model").ToString() = model AndAlso
               row("ImageURL").ToString() = imageURL Then
                    matchingRow = row
                    Exit For
                End If
            Next

            If matchingRow IsNot Nothing Then
                ' Replace the existing row with the same data
                matchingRow("VehicleNo") = txtVnum.Text
                matchingRow("Colour") = txtColour.Text
                matchingRow("Brand") = txtBrand.Text
                matchingRow("Model") = txtModel.Text
                matchingRow("ImageURL") = uploadedImageFileName ' Set the image file name
            Else
                ' Create a new row and populate it with data from textboxes
                Dim newRow As DataRow = dataTable.NewRow()
                newRow("VehicleNo") = vehicleNo ' Use only the entered Vehicle No
                newRow("Colour") = color
                newRow("Brand") = brand
                newRow("Model") = model
                newRow("ImageURL") = uploadedImageFileName ' Set the image file name

                ' Add the new row to the DataTable
                dataTable.Rows.Add(newRow)
            End If
        End If

        ' Update the session variable
        Session("VehicleData") = dataTable

        ' Bind the updated DataTable to the table control
        BindDataToTable(dataTable)

        ' Clear the textboxes
        txtVnum.Text = ""
        txtColour.Text = ""
        txtBrand.Text = ""
        txtModel.Text = ""
        btnUpload.Text = "Add File"
    End Sub

    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ' Clear the session variable
        Session.Clear()

        ' Reinitialize the session variable as an empty DataTable
        Dim dataTable As New DataTable()
        dataTable.Columns.Add("VehicleNo")
        dataTable.Columns.Add("Colour")
        dataTable.Columns.Add("Brand")
        dataTable.Columns.Add("Model")
        dataTable.Columns.Add("ImageURL")
        Session("VehicleData") = dataTable

        ' Bind the empty DataTable to the table control
        BindDataToTable(dataTable)

        ' Clear the textboxes
        txtVnum.Text = ""
        txtColour.Text = ""
        txtBrand.Text = ""
        txtModel.Text = ""
        btnUpload.Text = "Add File"
    End Sub


    Private deleteInProgress As Boolean = False ' Declare a class-level variable to track the delete operation

    Protected Sub btnDelete_Click(sender As Object, e As EventArgs)
        Dim button As Button = DirectCast(sender, Button)
        Dim controlId As String = button.ID ' Get the unique control ID

        ' Extract the row index from the controlId
        Dim rowIndexToDelete As Integer = Integer.Parse(controlId.Split("_")(1))

        ' Retrieve the DataTable from the session
        Dim dataTable As DataTable = CType(Session("VehicleData"), DataTable)

        ' Check if the rowIndexToDelete is valid
        If rowIndexToDelete >= 0 AndAlso rowIndexToDelete < dataTable.Rows.Count Then
            ' Delete the row at the specified index
            dataTable.Rows.RemoveAt(rowIndexToDelete)

            ' Apply the changes to the DataTable
            dataTable.AcceptChanges()

            ' Update the session variable
            Session("VehicleData") = dataTable

            ' Bind the updated DataTable to the table control
            BindDataToTable(dataTable)
        End If


    End Sub

    Private Sub btnUpdate_Click(sender As Object, e As EventArgs)
        Dim button As Button = DirectCast(sender, Button)
        Dim controlId As String = button.ID ' Get the unique control ID

        ' Extract the row index from the controlId
        Dim rowNumber As Integer = Integer.Parse(controlId.Split("_")(1))

        ' Retrieve the DataTable from the session
        Dim dataTable As DataTable = CType(Session("VehicleData"), DataTable)

        ' Check if the row number is valid
        If rowNumber >= 0 AndAlso rowNumber < dataTable.Rows.Count Then
            ' Get the selected row
            Dim selectedRow As DataRow = dataTable.Rows(rowNumber)

            ' Populate the textboxes with data from the selected row
            txtVnum.Text = selectedRow("VehicleNo").ToString()
            txtColour.Text = selectedRow("Colour").ToString()
            txtBrand.Text = selectedRow("Brand").ToString()
            txtModel.Text = selectedRow("Model").ToString()

            ' Check if there is an image URL in the selected row
            Dim imageURL As String = selectedRow("ImageURL").ToString()
            If Not String.IsNullOrEmpty(imageURL) Then
                btnUpload.Text = imageURL
            Else
                btnUpload.Text = "Add File"
            End If

            ' Store the row number in a hidden field or session variable to track the edited row
            Session("EditedRowIndex") = rowNumber
        End If
    End Sub

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)
        Dim fileUpload As FileUpload = CType(FindControl("fileUpload1"), FileUpload)

        If fileUpload.HasFile Then
            ' Get the file name and path
            Dim fileName As String = Path.GetFileName(fileUpload.FileName)
            Dim filePath As String = Server.MapPath("~/Uploads/") & fileName

            ' Save the uploaded file to the server
            fileUpload.SaveAs(filePath)

            ' You can now access 'filePath' to get the path of the saved file
            ' You can also update your session or database with this file information if needed
        Else
            ' Handle the case where no file is selected for upload
        End If
    End Sub


    Private Sub BindNationalityDropdown()
        Using connection As New SqlConnection(connectionString)
            Using cmd As New SqlCommand("SELECT ReferenceValue FROM ReferenceTable WHERE ReferenceType = 'Nationality'", connection)
                connection.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()

                While reader.Read()
                    txtNation.Items.Add(reader("ReferenceValue").ToString())
                End While

                reader.Close()
            End Using
        End Using
    End Sub

    Private Sub ClearFormFields()
        ' Clear the input fields
        lblUserNo.Text = ""
        txtName.Text = ""
        txtIc.Text = ""
        txtDesc.Text = ""
        txtDob.Text = ""
        txtNation.SelectedIndex = -1 ' Reset the selected nationality
        listGender.SelectedIndex = -1 ' Reset the selected gender
        txtAge.Text = ""
        txtVnum.Text = ""
        txtColour.Text = ""
        txtBrand.Text = ""
        txtModel.Text = ""
        btnUpload.Text = "Add File"

        ' Clear the data table rows
        vehicleDt.Rows.Clear()

        ' Rebind the data to the table
        BindDataToTable(vehicleDt)

    End Sub

    Private Sub InsertVehicleForm(userNo As Integer, connection As SqlConnection, vehicleDt As DataTable)
        ' Insert vehicle information for the UserNo
        Dim insertQuery As String = "INSERT INTO VehicleForm (VehicleNo, Colour, Brand, Model,ImageURL, UserNo) VALUES (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6)"

        For Each row As DataRow In vehicleDt.Rows
            Using cmdInsert As New SqlCommand(insertQuery, connection)
                cmdInsert.Parameters.AddWithValue("@Value1", row("VehicleNo"))
                cmdInsert.Parameters.AddWithValue("@Value2", row("Colour"))
                cmdInsert.Parameters.AddWithValue("@Value3", row("Brand"))
                cmdInsert.Parameters.AddWithValue("@Value4", row("Model"))
                cmdInsert.Parameters.AddWithValue("@Value5", row("ImageURL"))
                cmdInsert.Parameters.AddWithValue("@Value6", userNo)

                ' Execute the insert query
                cmdInsert.ExecuteNonQuery()
            End Using
        Next
    End Sub

    Private Sub UpdateVehicleForm(userNo As Integer, connection As SqlConnection, vehicleDt As DataTable)
        ' First, delete all existing records in VehicleForm for the specified UserNo
        Dim deleteQuery As String = "DELETE FROM VehicleForm WHERE UserNo = @UserNo"

        Using cmdDelete As New SqlCommand(deleteQuery, connection)
            cmdDelete.Parameters.AddWithValue("@UserNo", userNo)

            ' Execute the delete query
            cmdDelete.ExecuteNonQuery()
        End Using

        ' Now, insert the updated vehicle information for the UserNo
        InsertVehicleForm(userNo, connection, vehicleDt)
    End Sub

    Private Sub UpdateTableForm(userId As Integer, connection As SqlConnection)
        ' Update data in TableForm
        Dim updateQuery As String = "UPDATE TableForm SET Name = @Value1, IC = @Value2, Description = @Value3, DateOfBirth = @Value4, Nationality = @Value5, Gender = @Value6, AddedDate = @Value7, Age = @Value8 WHERE UserNo = @UserNo"

        Using cmdUpdate As New SqlCommand(updateQuery, connection)
            cmdUpdate.Parameters.AddWithValue("@Value1", txtName.Text)
            cmdUpdate.Parameters.AddWithValue("@Value2", txtIc.Text)
            cmdUpdate.Parameters.AddWithValue("@Value3", txtDesc.Text)
            cmdUpdate.Parameters.AddWithValue("@Value4", txtDob.Text)
            cmdUpdate.Parameters.AddWithValue("@Value5", txtNation.SelectedValue)
            cmdUpdate.Parameters.AddWithValue("@Value6", listGender.SelectedValue)
            cmdUpdate.Parameters.AddWithValue("@Value7", txtDate.Text)
            cmdUpdate.Parameters.AddWithValue("@Value8", txtAge.Text)
            cmdUpdate.Parameters.AddWithValue("@UserNo", userId)

            ' Execute the update query
            cmdUpdate.ExecuteNonQuery()
        End Using
    End Sub


    Private Function GetVehicleData(userNo As String) As DataTable
        Dim connectionString As String = "Your Connection String Name"

        ' Create a DataTable to store the vehicle data
        Dim vehicleData As New DataTable()

        Using connection As New SqlConnection(connectionString)
            connection.Open()

            ' Define your SQL query to retrieve vehicle data based on UserNo
            Dim query As String = "SELECT [VehicleNo], [Colour], [Brand], [Model], [ImageURL] FROM [VehicleForm] WHERE [UserNo] = @UserNo"

            Using command As New SqlCommand(query, connection)
                ' Add the UserNo parameter to the SQL query
                command.Parameters.AddWithValue("@UserNo", userNo)

                Using adapter As New SqlDataAdapter(command)
                    ' Fill the DataTable with the result of the SQL query
                    adapter.Fill(vehicleData)
                End Using
            End Using
        End Using

        ' Return the DataTable containing the vehicle data
        Return vehicleData
    End Function

    Private Function InsertTableForm(connection As SqlConnection) As Integer
        Dim userId As Integer = -1

        ' Insert data into TableForm
        Dim insertQuery As String = "INSERT INTO TableForm (Name, IC, Description, DateOfBirth, Nationality, Gender, AddedDate, Age) VALUES (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8); SELECT SCOPE_IDENTITY();"

        Using cmd As New SqlCommand(insertQuery, connection)
            ' ... (parameterized values)
            cmd.Parameters.AddWithValue("@Value1", txtName.Text)
            cmd.Parameters.AddWithValue("@Value2", txtIc.Text)
            cmd.Parameters.AddWithValue("@Value3", txtDesc.Text)
            cmd.Parameters.AddWithValue("@Value4", txtDob.Text)
            cmd.Parameters.AddWithValue("@Value5", txtNation.SelectedValue)
            cmd.Parameters.AddWithValue("@Value6", listGender.SelectedValue)
            cmd.Parameters.AddWithValue("@Value7", txtDate.Text)
            cmd.Parameters.AddWithValue("@Value8", txtAge.Text)

            ' Execute the insert query and retrieve the inserted userId
            userId = Convert.ToInt32(cmd.ExecuteScalar())
        End Using

        Return userId
    End Function



    Private Function DoesRowExist(dataTable As DataTable, vehicleNo As String, color As String, brand As String, model As String, imageURL As String) As Boolean
        For Each row As DataRow In dataTable.Rows
            If row("VehicleNo").ToString() = vehicleNo AndAlso
               row("Colour").ToString() = color AndAlso
               row("Brand").ToString() = brand AndAlso
               row("Model").ToString() = model AndAlso
                row("ImageURL").ToString() = imageURL Then
                ' Row with the same data already exists

                Return True
            End If
        Next
        Return False

    End Function


End Class




