﻿$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  destination   = $toolsDir    
  file          = "$toolsDir\wings-2.2.4.exe"    
  file64        = "$toolsDir\wings-x64-2.2.4.exe"    
  silentArgs	= "/S"
}

Install-ChocolateyInstallPackage @packageArgs
Write-Warning "OpenGL 2.1 for Windows is needed to launch Wings3D. See https://www.khronos.org/opengl/wiki/Getting_Started#Downloading_OpenGL"