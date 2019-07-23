﻿import-module au
 
function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {  
  $releases    = 'https://sourceforge.net/projects/qtpfsgui'
  $regex       = 'Luminance-HDR_v\.(?<Version>[\d\.]+)_Windows_64.exe'

  (Invoke-WebRequest -Uri $releases).RawContent -match $regex | Out-Null
  #$version = $matches.Version

  #$releasesUrl = 'https://sourceforge.net/projects/qtpfsgui/files/luminance/' + $version
  #$regexUrl    = 'Luminance-HDR_v\.(?<Version>[\d\.]+)_Windows_64.exe'

  return @{
    Version = $matches.Version
    URL64   = 'https://netix.dl.sourceforge.net/project/qtpfsgui/luminance/' + $version + '/Luminance-HDR_v.' + $version + '_Windows_64.zip'
  }
}

function global:au_SearchReplace {
    @{
       "legal\VERIFICATION.txt"  = @{
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL64)"     
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType64)"
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum64)"
        }

        "tools\chocolateyinstall.ps1" = @{
          "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\)(.*)`""          = "`$1$($Latest.FileName64)`""
          "([$]toolsDir\\Luminance-HDR_v\.)[\d\.]+(_Windows_64)\ "   = "`${1}$($Latest.Version)`$2 "
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    update -ChecksumFor none
}