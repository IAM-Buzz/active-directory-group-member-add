# Read the group names from a text file
$groupNames = Get-Content "C:\path\to\groupnames.txt"

# Define the parent OU name
$parentOUName = "OU=abc,DC=example,DC=com"

# Get all the sub-OU names under the parent OU
$subOUNames = Get-ADOrganizationalUnit -Filter "Name -ne 'Domain Controllers'" -SearchBase $parentOUName | Select-Object -ExpandProperty Name

# Loop through each sub-OU
foreach ($subOUName in $subOUNames) {
    # Get the distinguished name of the sub-OU
    $subOUDN = "OU=$subOUName,$parentOUName"

    # Get all the users in the sub-OU that are not already members of the groups
    $users = Get-ADUser -Filter * -SearchBase $subOUDN | Where-Object {
        $_.DistinguishedName -notmatch "^CN=.*,$subOUDN" -and
        $_.Enabled -eq $true
    }

    # Loop through each group and add the new users to the group
    foreach ($groupName in $groupNames) {
        $group = Get-ADGroup -Identity $groupName
        $newUsers = $users | Where-Object {
            $_.DistinguishedName -match "^CN=.*,$subOUDN" -and
            $_.MemberOf -notcontains $group.DistinguishedName
        }
        if ($newUsers.Count -gt 0) {
            Add-ADGroupMember -Identity $group -Members $newUsers
            Write-Output "$($newUsers.Count) new users added to $groupName in $subOUName"
        }
    }
}

#In this example, the Get-Content cmdlet is used to read the contents of a file containing the group names, and the results are stored in the $groupNames variable as an array. The script then loops through each group name in the array and performs the same operations as before to add new users to the group.