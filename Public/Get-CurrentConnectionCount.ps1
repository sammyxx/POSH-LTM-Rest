﻿Function Get-CurrentConnectionCount {
<#
.SYNOPSIS
    Get the count of the specified pool member's current connections
#>
    param(
        [Parameter(Mandatory=$true)]$F5session,
        [Parameter(Mandatory=$true)]$ComputerName,
        [Parameter(Mandatory=$true)]$PoolName
    )

    $IPAddress = (Get-PoolMember -F5session $F5session -ComputerName $ComputerName -PoolName $PoolName).Name

    $Partition = 'Common'
    if ($PoolName -match '^[/\\](?<Partition>[^/\\]*)[/\\](?<Name>[^/\\]*)$') {
        $Partition = $matches['Partition']
        $PoolName = $matches['Name']
    }

    $PoolMember = $F5session.BaseURL + "pool/~$Partition~$PoolName/members/~$Partition~$IPAddress/stats"

    $PoolMemberJSON = Invoke-RestMethodOverride -Method Get -Uri $PoolMember -Credential $F5session.Credential

    #Return the number of current connections for this member of this pool
    $PoolMemberJSON.entries.'serverside.curConns'.value

}