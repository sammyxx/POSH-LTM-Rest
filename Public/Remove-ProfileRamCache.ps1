﻿Function Remove-ProfileRamCache{
<#
.SYNOPSIS
    Delete the contents of a RAM cache for the specified profile
.NOTES
    Example profile: "profile/http/ramcache"
#>
    param(
        [Parameter(Mandatory=$true)]$F5session,
        [Parameter(Mandatory=$true)]$ProfileName
    )

    $ProfileURL = $F5session.BaseURL +$ProfileName

    Try {
        $response = Invoke-RestMethodOverride -Method DELETE -Uri "$ProfileURL" -Credential $F5session.Credential
    }
    Catch {
        Write-Error "Failed to clear the ram cache for the $ProfileName profile."
        Write-Error ("StatusCode:" + $_.Exception.Response.StatusCode.value__)
        Write-Error ("StatusDescription:" + $_.Exception.Response.StatusDescription)
    }

}