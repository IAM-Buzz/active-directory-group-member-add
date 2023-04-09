# AD Group Member Add

This PowerShell script can be used to automatically add newly added members in Active Directory to specific groups. It scans all sub-OUs under a parent OU, looks for new users, and adds them to specified groups in their corresponding OUs.

## Usage

1. Clone this repository to your local machine.
2. Open the `ADGroupMemberAdder.ps1` script in a PowerShell editor.
3. Edit the script to set the parent OU name and group names.
4. Save the script.
5. Run the script in PowerShell.

## Requirements

- Windows PowerShell 5.1 or later
- Active Directory PowerShell module
