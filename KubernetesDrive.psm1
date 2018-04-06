using namespace Microsoft.PowerShell.SHiPS

# Define the base class so that the derived class does not need to define GetChildItemDynamicParameters.
class ClusterBase : SHiPSDirectory
{
    # Make sure this constructor is defined so that a derived class, Nature, can be created as a psdrive root
    ClusterBase([string]$name): base($name)
    {
    }
}

class Cluster : ClusterBase
{
    Cluster([string]$name): base($name)
    {
    }

    [object[]] GetChildItem()
    {
        $obj =  @()

        $namespaces = Get-Namespaces
        $obj += $namespaces

        return $obj;
    }
}

[SHiPSProvider()]
class kubernetesNamespace: SHiPSDirectory
{
    Hidden [object] $data = $null

    [string] $kind
    [datetime] $creationTimestamp
    [string] $labels
    [string] $uid
    [string] $generateName

    kubernetesNamespace([Object] $namespaceData): base ($namespaceData.metadata.name) {
        $this.data = $namespaceData
        $this.kind = $this.data.kind

        $this.creationTimeStamp = [datetime]::Parse($this.data.metadata.creationTimestamp)
        $this.labels = $this.data.metadata.labels
        $this.uid = $this.data.metadata.uid
        $this.generateName = $this.data.metadata.generateName
    }

    [object[]] GetChildItem()
    {
        $obj =  @()

        $items = Get-AllForNamespace -Namespace $this.name
        $obj  += $items
        return $obj
    }

    # # Define dynamic parameters for Get-ChildItem
    # [object] TypeDynamicParameter()
    # {
    #     return [TypeDynamicParameter]::new()
    # }
}


[SHiPSProvider()]
class kubernetesPod: SHiPSLeaf
{
    Hidden [object] $data = $null

    [string] $kind
    [datetime] $creationTimestamp
    [string] $labels
    [string] $uid
    [string] $generateName

    kubernetesPod([Object] $podData): base ($podData.metadata.name) {
        $this.data = $podData
        $this.kind = $this.data.kind

        $this.creationTimeStamp = [datetime]::Parse($this.data.metadata.creationTimestamp)
        $this.labels = $this.data.metadata.labels
        $this.uid = $this.data.metadata.uid
        $this.generateName = $this.data.metadata.generateName
    }
}

[SHiPSProvider()]
class kubernetesService: SHiPSLeaf
{
    Hidden [object] $data = $null

    [string] $kind
    [datetime] $creationTimestamp
    [string] $labels
    [string] $uid
    [string] $generateName
    [string] $type

    kubernetesService([Object] $podData): base ($podData.metadata.name) {
        $this.data = $podData
        $this.kind = $this.data.kind

        $this.creationTimeStamp = [datetime]::Parse($this.data.metadata.creationTimestamp)
        $this.labels = $this.data.metadata.labels
        $this.uid = $this.data.metadata.uid
        $this.generateName = $this.data.metadata.generateName
        $this.type = $this.data.metadata.type
    }
}

class TypeDynamicParameter
{
    [Parameter()]
    [ValidateSet("Pod", "Service", "Deployment", "All")]
    [string]$Type = "All"
}

function Get-Namespaces()
{
    $obj = @()
    $items = ([string[]](kubectl get namespaces -o json) | ConvertFrom-Json).items

    foreach ($item in $items) {
        $parsedItem = [kubernetesNamespace]::new($item)
        $obj += $parsedItem
    }

    return $obj;
}

function Get-AllForNamespace($Namespace)
{
    $obj = @()
    $items = ([string[]](kubectl --namespace $Namespace get all -o json) | ConvertFrom-Json).items

    foreach ($item in $items) {
        switch ($item.kind) {
            'Pod' {
                $pod = [kubernetesPod]::new($item)
                $obj += $pod
            }
            'Deployment' {
            }
            'ReplicaSet' {
            }
            'Service' {
                $service = [kubernetesService]::new($item)
                $obj += $service
            }
        }
    }

    return $obj;
}

function k8 {
    #[CmdletBinding()]
    param ()
    begin {
        $namespace = Split-Path -Path (Get-Location) -Leaf
    }
    process {
        kubectl --namespace $namespace $args
    }
}
