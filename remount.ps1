Import-Module -Name SHiPS -Force
Remove-Module -Name KubernetesDrive -ErrorAction SilentlyContinue
Import-Module .\KubernetesDrive.psm1 -Force
Remove-PSDrive kube -ErrorAction SilentlyContinue
Write-Output "New-PSDrive -Name kube -PSProvider SHiPS -Root ""KubernetesDrive#Cluster"""
