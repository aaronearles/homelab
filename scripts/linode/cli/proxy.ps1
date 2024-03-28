# This is a powershell script that creates a new Linode Nanode instance running Squid, opens an SSH session to the new instance tunnelling localhost:443 to proxy:3128
# Once connected SSH session, you can set your local browser proxy settings to use localhost:443 to access the internet using a Linode public IP
# Requires Linode CLI: https://www.linode.com/docs/products/tools/cli/guides/install/
# Requires Get-Random: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-random
# Requires a valid SSH key! You can generate a keypaid using 'ssh-keygen -m PEM -t rsa -b 2048'
# Requires a valid stackscript_id, 1117817 is private. It's contents are available in ../stackscripts/proxy.shj

# function Get-RandomPassword {
#     param (
#         [Parameter(Mandatory)]
#         [int] $length,
#         [int] $amountOfNonAlphanumeric = 1
#     )
#     Add-Type -AssemblyName 'System.Web'
#     return [System.Web.Security.Membership]::GeneratePassword($length, $amountOfNonAlphanumeric)
# }
#Replaced above function with PSPasswordGenerator module for pwsh7 compatibility, see https://github.com/rhymeswithmogul/PSPasswordGenerator or 'Install-Module PSPasswordGenerator'

$password = Get-RandomPassword -Length 32
$output = linode-cli linodes create `
--label "proxy" `
--root_pass $password `
--region us-west `
--type g6-nanode-1 `
--image linode/alpine3.17 `
--authorized_keys "ssh-ed25519 abcd1234" `
--authorized_users "newuser" `
--stackscript_id "1117817" `
--text `
--delimiter ","

$output.split(",")
$splitOutput = $output |ConvertFrom-Csv -Header id, label, region, type, image, status, ipv4
$linodeCliOutput = $splitOutput | Select-Object -skip 2
$newhostip = $linodeCliOutput.ipv4
$newhostid = $linodeCliOutput.id
Remove-Variable password
clear
Write-Host New Linode ID is $newhostid
Write-Host IP Address: $newhostip
Write-Host 
Write-Host "Sleeping for 90 more seconds"
sleep 30
Write-Host "Sleeping for 60 more seconds"
sleep 30
Write-Host "Sleeping for 30 more seconds"
sleep 20
Write-Host "Sleeping for 10 more seconds"
sleep 10
Write-Host Attempting to connect to $newhostip on SSH...
Write-Host
ssh -L 127.0.0.1:443:localhost:3128 newuser@$newhostip -p 443
clear
Write-Host Sleeping for 10 seconds before deleting $newhostid
sleep 10
linode-cli linodes delete $newhostid

linode-cli linodes ls
