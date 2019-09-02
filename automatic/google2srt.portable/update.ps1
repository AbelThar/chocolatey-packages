﻿import-module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $releases = 'https://sourceforge.net/projects/google2srt/files/Google2SRT'
    $regex    = 'google2srt-(?<Version>[\d\.]+).msi'

    (Invoke-WebRequest -Uri $releases).RawContent -match $regex | Out-Null
    $version = $matches.Version

    return @{
        Version = $version
        URL32   = 'https://freefr.dl.sourceforge.net/project/google2srt/Google2SRT/' + $version + '/Google2SRT-' + $version + '.zip'
    }
}

function global:au_SearchReplace {
    @{
       "legal\VERIFICATION.txt"  = @{            
            "(?i)(x32: ).*"             = "`${1}$($Latest.URL32)"
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL32)"            
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType32)"
            "(?i)(checksum32:).*"       = "`${1} $($Latest.Checksum32)"
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum32)"
        }

        "tools\chocolateyinstall.ps1" = @{        
          "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`$1$($Latest.FileName32)`""
          "([$]toolsDir `"Google2SRT-)[\d\.]+(\\Google2SRT.exe`")" = "`${1}$($Latest.Version)`${2}"
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    update -ChecksumFor none
}
