Imports System.Data
Imports System.Data.SqlClient
Imports System.Net
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

Public Class VehicleForm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check if the query parameter "userNo" is present in the URL
            If Request.QueryString("userNo") IsNot Nothing Then
                Dim userNo As String = Request.QueryString("userNo")

                ' Create an instance of WebClient to make an HTTP GET request
                Dim webClient As New WebClient()

                ' Define the URL of your VehicleController API
                Dim apiUrl As String = $"https://localhost:44371/api/vehicle/{userNo}"

                Try
                    ' Download the JSON response from the API
                    Dim jsonString As String = webClient.DownloadString(apiUrl)


                    ' Parse the JSON response and convert it to a DataTable
                    Dim vehicleData As DataTable = JsonConvert.DeserializeObject(Of DataTable)(jsonString)


                    ' Bind the vehicle data to the table in VehicleForm1
                    BindVehicleData(vehicleData)
                Catch ex As Exception
                    ' Handle any exceptions that may occur during the request
                    Response.Write("Error: " & ex.Message)
                End Try
            Else
                ' Handle the case where the "userNo" query parameter is missing
                ' You can display a message or take appropriate action
            End If
        End If
    End Sub

   Private Sub BindVehicleData(ByVal data As DataTable)
    ' Bind the vehicle data to the table in VehicleForm1
    For Each row As DataRow In data.Rows
        Dim vehicleNo As String = row("VehicleNo").ToString()
        Dim colour As String = row("Colour").ToString()
        Dim brand As String = row("Brand").ToString()
        Dim model As String = row("Model").ToString()
            Dim imageURL As String = "Uploads/" & HttpUtility.UrlEncode(row("ImageURL").ToString())
            Dim imageURL2 As String = HttpUtility.UrlEncode(row("ImageURL").ToString())

            ' Create a new table row and cells to display the vehicle data
            Dim tableRow As New TableRow()

        Dim cellVehicleNo As New TableCell()
        cellVehicleNo.Text = vehicleNo

        Dim cellColour As New TableCell()
        cellColour.Text = colour

        Dim cellBrand As New TableCell()
        cellBrand.Text = brand

        Dim cellModel As New TableCell()
        cellModel.Text = model

            ' Create a cell for the image with a clickable link
            Dim cellImage As New TableCell()
            cellImage.Width = 250 ' Set the width to 250 pixels


            If Not String.IsNullOrEmpty(imageURL) Then
            ' Create a view image link
            Dim viewImageLink As New HyperLink()
            viewImageLink.NavigateUrl = imageURL ' Set the link to the image URL
            viewImageLink.Text = "View Image" ' Display "View Image" as the link text
            viewImageLink.Target = "_blank" ' Open the link in a new tab

            ' Create a download image link
            Dim downloadImageLink As New HyperLink()
                downloadImageLink.NavigateUrl = $"DownloadImage.ashx?filename={imageURL2}" ' Link to the image download handler
                downloadImageLink.Text = "Download Image" ' Display "Download Image" as the link text
            downloadImageLink.Target = "_blank" ' Open the link in a new tab

            ' Add both view and download links to the cell
            cellImage.Controls.Add(viewImageLink)
            cellImage.Controls.Add(New LiteralControl(" | ")) ' Add a separator
            cellImage.Controls.Add(downloadImageLink)
        Else
            ' Handle the case where no image is available
            cellImage.Text = "No Image Available"
        End If

        ' Add the cells to the table row
        tableRow.Cells.Add(cellVehicleNo)
        tableRow.Cells.Add(cellColour)
        tableRow.Cells.Add(cellBrand)
        tableRow.Cells.Add(cellModel)
        tableRow.Cells.Add(cellImage) ' Add the image cell

        ' Add the table row to the table
        tblVehicle.Rows.Add(tableRow)
    Next
End Sub

End Class