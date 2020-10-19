#Enter container for grep StaticIp:
# ---------------------------VVVVVVVV--
$users = Get-ADGroupMember 'Group-users3'
#Change path for output file:
$path = $env:UserProfile+'\desktop\users-static.txt'


function GetUsers {
    foreach ($user in $users)
    {
        $one_record = (GetStaticIp $user.SamAccountName)
        $one_record >> $path
        
    }
}


function GetStaticIp ($user){
    $name = ''
    $staticip = '' 
    $req = Get-ADUser $user -Properties *

    foreach ($item in $req)
    {
        $name = $item | Select 'CN', 'msRADIUSFramedIPAddress'
        if ($name.msRADIUSFramedIPAddress) {
            $staticip = [System.Net.IPAddress]::Parse($name.msRADIUSFramedIPAddress).IPAddressToString
     }
        else {$staticip = 'None'}
        return ($name.CN + ' -- ' + $staticip)
    }
}


GetUsers