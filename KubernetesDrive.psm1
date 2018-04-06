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

        $namespaces += Get-Namespaces
        $namespaces | ForEach-Object {
           $obj += [kubernetesNamespace]::new($_.name)
        }

        return $obj;
    }
}

[SHiPSProvider()]
class kubernetesNamespace: SHiPSDirectory
{
    kubernetesNamespace([string] $name): base($name)
    {
    }

    [object[]] GetChildItem()
    {
        $obj =  @()
        return $obj
    }

    # # Define dynamic parameters for Get-ChildItem
    # [object] TypeDynamicParameter()
    # {
    #     return [TypeDynamicParameter]::new()
    # }
}


[SHiPSProvider()]
class k8sPod: SHiPSLeaf
{
    [string] $country
    [string] $company
    [string] $twitter
    [bool] $MVP
    [string] $bio

    Hidden [object] $podData = $null

    k8sPod(): base()
    {
    }

    k8sPod([String] $name, [Object] $podData): base($name)
    {
      $this.podData = $podData
      $this.country = $podData.country
      $this.company = $podData.company
      $this.Twitter = $podData.Twitter
      $this.MVP = $podData.MVP
      $this.BIO = $podData.BIO
    }
}


class TypeDynamicParameter
{
    [Parameter()]
    [ValidateSet("Pod", "Service", "All")]
    [string]$Type = "All"
}

function Get-Namespaces()
{
    $items = ([string[]](kubectl get namespaces -o json) | ConvertFrom-Json).items
    $metadata = $items.metadata
    return $metadata;
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