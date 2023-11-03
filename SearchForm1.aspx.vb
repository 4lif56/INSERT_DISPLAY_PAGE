Imports System.Data.SqlClient
Imports System.Threading
Imports System.Web.Services.Description
Imports System.Net
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json

Public Class SearchForm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim vehicleNo As String = Request.QueryString("vehicleNo")
            Dim colour As String = Request.QueryString("colour")
            Dim brand As String = Request.QueryString("brand")
            Dim model As String = Request.QueryString("model")
            Dim imageURL As String = Request.QueryString("imageURL")
        End If

        ' Check if it's a postback triggered by the delete button
        Dim eventTarget As String = Request("__EVENTTARGET")
        If eventTarget = "DeleteRowAndData" Then
            ' Get the userNo from the postback event argument
            Dim userNo As String = Request("__EVENTARGUMENT")
            ' Call the server-side delete method
            DeleteRowAndData(userNo)
        End If

        ' Call the method to fetch and display the data
        DisplayData()
    End Sub


    Protected Sub btnEdit_Click(sender As Object, e As EventArgs) Handles btnEdit.Click
        ' Get the selected userNo from the gridview
        Dim userNo As String = GetUserNoFromSelectedRow()

        If Not String.IsNullOrEmpty(userNo) Then
            ' Redirect to WebForm1 with the selected UserNo
            Response.Redirect("WebForm1.aspx?UserNo=" & userNo)
        Else
            ' If no row is selected, it means you want to add a new record, so redirect to VehicleForm1
            Response.Redirect("VehicleForm1.aspx")
        End If
    End Sub

    Private Function GetUserNoFromSelectedRow() As String
        ' Iterate through the rows in tblInfo to find the selected row
        For Each row As GridViewRow In tblInfo.Rows
            Dim chkSelect As CheckBox = CType(row.FindControl("chkSelect"), CheckBox)
            If chkSelect IsNot Nothing AndAlso chkSelect.Checked Then
                ' The row is selected, get the UserNo from the hidden field
                Dim userNoCell As TableCell = row.Cells(1) ' Assuming UserNo is in the second cell
                Return userNoCell.Text
            End If
        Next
        Return String.Empty ' Return empty string if no row is selected
    End Function

    Protected Sub btnDelete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click
        ' Check if the Delete button is enabled
        If Not btnDelete.Enabled Then
            ' Get the userNo from the request parameters
            Dim userNo As String = Request("UserNo")

            ' Check if userNo is not empty (to avoid SQL injection)
            If Not String.IsNullOrEmpty(userNo) Then
                ' Assuming you have a database connection, you can execute a SQL query to delete the row and its data
                Dim connectionString As String = "Your Connection String Name"

                Using connection As New SqlConnection(connectionString)
                    connection.Open()

                    ' Define your SQL query to delete the row and its data based on userNo
                    Dim sqlQuery As String = "DELETE FROM TableForm WHERE UserNo = @UserNo;" &
                                        "DELETE FROM VehicleForm WHERE UserNo = @UserNo;"

                    Using cmd As New SqlCommand(sqlQuery, connection)
                        cmd.Parameters.AddWithValue("@UserNo", userNo)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                ' Trigger a postback to refresh the page
                ClientScript.RegisterStartupScript(Me.GetType(), "RefreshPage", "__doPostBack('', '');", True)
            End If
        End If
    End Sub

    Public Sub DeleteRowAndData(ByVal userNo As String)
        ' Define your connection string
        Dim connectionString As String = "Your Connection String Name"

        ' Create a SQL connection
        Using connection As New SqlConnection(connectionString)
            ' Define the SQL DELETE command
            Dim sqlDelete As String = "DELETE FROM TableForm WHERE UserNo = @UserNo; DELETE FROM VehicleForm WHERE UserNo = @UserNo"

            ' Create a SQL command with parameters
            Using command As New SqlCommand(sqlDelete, connection)
                ' Set the parameter value
                command.Parameters.AddWithValue("@UserNo", userNo)

                ' Open the connection
                connection.Open()

                ' Execute the SQL command
                command.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub DisplayData()
        ' Define your database connection string
        Dim connectionString As String = "Your Connection String Name"

        ' Create a SQL query to fetch the data you need
        Dim query As String = "SELECT TF.Name, TF.IC, TF.Description, TF.DateOfBirth, TF.Nationality, TF.Gender, TF.Age, TF.UserNo, " &
                "VF.VehicleNo, VF.Colour, VF.Brand, VF.Model, VF.ImageURL " &
                "FROM TableForm TF " &
                "LEFT JOIN VehicleForm VF ON TF.UserNo = VF.UserNo WHERE 1=1 " ' The "WHERE 1=1" ensures the query always starts with a true condition

        ' Check if both filters are applied
        Dim isFilterApplied As Boolean = False

        If txtFilter.Text.Trim() <> "" Then
            query &= "AND TF.Name LIKE @Name "
            isFilterApplied = True
        End If

        If listGender.SelectedValue <> "All" Then
            query &= "AND TF.Gender = @Gender "
            isFilterApplied = True
        End If

        ' Create a SqlConnection and a SqlCommand
        Using connection As New SqlConnection(connectionString)
            Using cmd As New SqlCommand(query, connection)
                Try
                    ' Open the database connection
                    connection.Open()

                    ' Set the parameter values for the filters
                    If txtFilter.Text.Trim() <> "" Then
                        cmd.Parameters.AddWithValue("@Name", "%" & txtFilter.Text.Trim() & "%")
                    End If

                    If listGender.SelectedValue <> "All" Then
                        cmd.Parameters.AddWithValue("@Gender", listGender.SelectedValue)
                    End If

                    ' Execute the SQL query and retrieve the data
                    Dim reader As SqlDataReader = cmd.ExecuteReader()

                    ' Create a HashSet to keep track of unique UserNo values
                    Dim uniqueUserNos As New HashSet(Of String)()

                    Dim counter As Integer = 1 ' Initialize a counter

                    While reader.Read()
                        Dim row As New TableRow()
                        Dim userNo As String = reader("UserNo").ToString()

                        ' Check if this UserNo has already been added to the table
                        If Not uniqueUserNos.Contains(userNo) Then
                            ' Add the auto-generated number as the first cell
                            row.Cells.Add(New TableCell() With {.Text = counter.ToString()})
                            counter += 1 ' Increment the counter for the next row

                            ' Add the UserNo (hidden) as the second cell
                            Dim userNoCell As New TableCell()
                            userNoCell.Text = reader("UserNo").ToString()
                            userNoCell.Style("display") = "none"
                            row.Cells.Add(userNoCell)

                            ' Add the other cells with data
                            row.Cells.Add(New TableCell() With {.Text = reader("Name").ToString()})
                            row.Cells.Add(New TableCell() With {.Text = reader("IC").ToString()})
                            row.Cells.Add(New TableCell() With {.Text = reader("Description").ToString()})
                            row.Cells.Add(New TableCell() With {.Text = reader("DateOfBirth").ToString()})
                            row.Cells.Add(New TableCell() With {.Text = reader("Nationality").ToString()})
                            row.Cells.Add(New TableCell() With {.Text = reader("Gender").ToString()})
                            row.Cells.Add(New TableCell() With {.Text = reader("Age").ToString()})

                            Dim vehicleNocell As New TableCell()
                            vehicleNocell.Text = reader("VehicleNo").ToString()
                            vehicleNocell.Style("display") = "none"
                            row.Cells.Add(vehicleNocell)

                            Dim colourcell As New TableCell()
                            colourcell.Text = reader("Colour").ToString()
                            colourcell.Style("display") = "none"
                            row.Cells.Add(colourcell)

                            Dim brandcell As New TableCell()
                            brandcell.Text = reader("Brand").ToString()
                            brandcell.Style("display") = "none"
                            row.Cells.Add(brandcell)

                            Dim modelcell As New TableCell()
                            modelcell.Text = reader("Model").ToString()
                            modelcell.Style("display") = "none"
                            row.Cells.Add(modelcell)

                            Dim imageURLcell As New TableCell()
                            imageURLcell.Text = reader("ImageURL").ToString()
                            imageURLcell.Style("display") = "none"
                            row.Cells.Add(imageURLcell)

                            tblInfo.Rows.Add(row)

                            ' Add the UserNo to the HashSet to prevent duplication
                            uniqueUserNos.Add(userNo)
                        End If
                    End While

                    ' Close the database connection and the reader
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


End Class
