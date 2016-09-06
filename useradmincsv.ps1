# Created by Scott Rhodes Jr.

# Connects to Azure and assignes the user as a variable 
$UserCredential = Get-Credential
#Imports the Microsoft Online Module
Import-Module MsOnline
# Connects to the MSOL Service
Connect-MsolService -Credential $UserCredential
# Creates a new PowerShell session with Exchange Online and assigns it to a variable
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Imports the new Exchange session into the current PowerShell session"
Import-PSSession $Session

# Imports the CSV file provided in the directory and makes the user variables
$users = Import-Csv C:\Users\scot5644\Desktop\import1.csv
# Runs through users imported on csv and creates their office365 user
$users | ForEach-Object { New-MsolUser -UserPrincipalName $_."User Name" -FirstName $_."First Name" -LastName $_."Last Name" -DisplayName $_."Display Name" -Title $_."Job Title" -Department $_."Department" -Office $_."Office Number" -PhoneNumber $_."Office Phone" -MobilePhone $_."Mobile Phone" -Fax $_."Fax" -StreetAddress $_."Address" -City $_."City" -State $_."State or Province" -PostalCode $_."State or Province" -Country $_."Country or Region" | select UserPrincipalName,Password }
# Assigns Password admin role for users imported
$users | ForEach-Object { Add-MsolRoleMember -RoleName "Helpdesk Administrator" -RoleMemberEmailAddress $_."User Name" }

# Ends the session and logs the user out gracefully
Remove-PSSession $Session