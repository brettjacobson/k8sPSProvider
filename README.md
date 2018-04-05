# Kubernetes SHiPS Provider

PowerShell SHiPS provider for Kubernetes kubectl

Make your kubernetes cluster look like a Drive!  Delve into namespaces as if they were a directory!

--WORK IN PROGRESS--

<https://github.com/PowerShell/SHiPS/blob/development/docs/README.md>
<https://github.com/PowerShell/SHiPS/blob/development/samples/DynamicParameter/DynamicParameter.psm1>
<https://github.com/PowerShell/SHiPS/blob/development/samples/FileSystem/FileSystem.psm1>

<https://github.com/rchaganti/PSConfDrive>
<http://www.powershellmagazine.com/2018/04/03/psconfeu-agenda-as-a-powershell-drive-using-ships/>

```powershell
Install-Module -Name SHiPS -Force   # as Administrator!
```

```powershell
Import-Module -Name SHiPS -Force
Import-Module KubernetesDrive -Force
Remove-PSDrive kube -ErrorAction SilentlyContinue
New-PSDrive -Name kube -PSProvider SHiPS -Root KubernetesDrive#Cluster
```
