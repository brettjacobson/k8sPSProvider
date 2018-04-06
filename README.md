# Kubernetes SHiPS Provider

PowerShell SHiPS provider for Kubernetes kubectl

Make your kubernetes cluster look like a Drive!  Delve into namespaces as if they were a directory!

```powershell
Install-Module -Name SHiPS -Force   # as Administrator!
```

After installing the module, import the module and mount a drive.

```powershell
Import-Module -Name SHiPS -Force
Import-Module KubernetesDrive -Force
Remove-PSDrive kube -ErrorAction SilentlyContinue
New-PSDrive -Name kube -PSProvider SHiPS -Root KubernetesDrive#Cluster
```

Now, you can do the following:

```powershell
cd kube:
dir
cd <some-namespace>
k8 get pods
```

`k8` is a PowerShell function that executes `kubectl` and supplies the `--namespace` parameter with the value of the folder you are in on the kube: drive.

--WORK IN PROGRESS--

<https://github.com/PowerShell/SHiPS/blob/development/docs/README.md>
<https://github.com/PowerShell/SHiPS/blob/development/samples/DynamicParameter/DynamicParameter.psm1>
<https://github.com/PowerShell/SHiPS/blob/development/samples/FileSystem/FileSystem.psm1>

<https://github.com/rchaganti/PSConfDrive>
<http://www.powershellmagazine.com/2018/04/03/psconfeu-agenda-as-a-powershell-drive-using-ships/>
