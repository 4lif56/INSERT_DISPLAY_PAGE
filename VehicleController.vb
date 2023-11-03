Imports System.Data.SqlClient
Imports System.Net
Imports System.Web.Http
Imports Microsoft.VisualBasic.ApplicationServices

Namespace Controllers
    Public Class VehicleController

        Inherits ApiController

        ' GET: api/Vehicle/5
        Public Function GetVehicles(ByVal id As String) As List(Of Vehicle)
            Dim connectionString As String = "Data Source=ALIFAMRAN-MBP;Initial Catalog=userForm;Persist Security Info=True;User ID=sa;Password=P@$$w0rd"
            Dim vehicles As New List(Of Vehicle)()

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim query As String = "SELECT [VehicleNo], [Colour], [Brand], [Model], [ImageURL] FROM [VehicleForm] WHERE [UserNo] = @UserNo"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserNo", id)

                    Using reader As SqlDataReader = command.ExecuteReader()
                        While reader.Read()
                            ' Data was found, create a new Vehicle instance for each row
                            Dim vehicleData As New Vehicle()
                            vehicleData.vehicleNo = reader("VehicleNo").ToString()
                            vehicleData.brand = reader("Brand").ToString()
                            vehicleData.colour = reader("Colour").ToString()
                            vehicleData.model = reader("Model").ToString()
                            vehicleData.imageURL = reader("ImageURL").ToString() ' Ensure that "ImageURL" is correctly spelled

                            vehicles.Add(vehicleData)
                        End While
                    End Using
                End Using
            End Using

            Return vehicles
        End Function

        ' POST: api/Vehicle
        Public Sub PostVehicle(ByVal id As String, <FromBody()> ByVal vehicle As Vehicle)
            Dim connectionString As String = "Data Source=ALIFAMRAN-MBP;Initial Catalog=userForm;Persist Security Info=True;User ID=sa;Password=P@$$w0rd"

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim query As String = "INSERT INTO [VehicleForm] ([UserNo], [VehicleNo], [Colour], [Brand], [Model], [ImageURL]) " &
                      "VALUES (@UserNo, @VehicleNo, @Colour, @Brand, @Model, @ImageURL)"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserNo", id)
                    command.Parameters.AddWithValue("@VehicleNo", vehicle.vehicleNo)
                    command.Parameters.AddWithValue("@Colour", vehicle.colour)
                    command.Parameters.AddWithValue("@Brand", vehicle.brand)
                    command.Parameters.AddWithValue("@Model", vehicle.model)
                    command.Parameters.AddWithValue("@ImageURL", vehicle.imageURL)

                    command.ExecuteNonQuery()
                End Using
            End Using
        End Sub

        ' PUT: api/Vehicle/5
        Public Sub PutVehicle(ByVal id As String, <FromBody()> ByVal updatedVehicle As Vehicle)
            Dim connectionString As String = "Data Source=ALIFAMRAN-MBP;Initial Catalog=userForm;Persist Security Info=True;User ID=sa;Password=P@$$w0rd"

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim query As String = "UPDATE [VehicleForm] " &
    "SET [VehicleNo] = @NewVehicleNo, [Colour] = @Colour, [Brand] = @Brand, [Model] = @Model, [ImageURL] = @ImageURL " &
    "WHERE [UserNo] = @UserNo AND [VehicleNo] = @VehicleNo"

                Try
                    Using command As New SqlCommand(query, connection)
                        command.Parameters.AddWithValue("@UserNo", id)
                        command.Parameters.AddWithValue("@VehicleNo", updatedVehicle.vehicleNo) ' The new VehicleNo (GHI789)
                        command.Parameters.AddWithValue("@Colour", updatedVehicle.colour)
                        command.Parameters.AddWithValue("@Brand", updatedVehicle.brand)
                        command.Parameters.AddWithValue("@Model", updatedVehicle.model)
                        command.Parameters.AddWithValue("@ImageURL", updatedVehicle.imageURL)

                        command.ExecuteNonQuery()
                    End Using
                Catch ex As Exception
                    ' Handle the exception here, e.g., log the error, show a message to the user, or perform any necessary cleanup.
                    ' You can also re-throw the exception if needed.
                End Try
            End Using
        End Sub

        ' DELETE: api/Vehicle/5
        Public Sub DeleteVehicle(ByVal userId As String, ByVal vehicleNo As String)
            Dim connectionString As String = "Data Source=ALIFAMRAN-MBP;Initial Catalog=userForm;Persist Security Info=True;User ID=sa;Password=P@$$w0rd"

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim query As String = "DELETE FROM [VehicleForm] WHERE [UserNo] = @UserNo AND [VehicleNo] = @VehicleNo"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@UserNo", userId)
                    command.Parameters.AddWithValue("@VehicleNo", vehicleNo)
                    command.ExecuteNonQuery()
                End Using
            End Using
        End Sub
    End Class
End Namespace
