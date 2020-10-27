workflow CreateWebVM
{
    Param
    (            
        [parameter(Mandatory=$true)]
        [String]
        $CloudServiceName,
        [parameter(Mandatory=$true)]
        [String]
        $VMBaseName
    )
    "Please be patient while I connect to your Azure subscription..."
    $SubscriptionName = "BizsparkAzureConnection"
    ConnectToAzure -AzureConnectionName $SubscriptionName
    Select-AzureSubscription $SubscriptionName
    # Following should be read from config settings
    $imageName = Get-AutomationVariable -Name 'WebImageName' # base image
    $username = Get-AutomationVariable -Name 'LinuxUser'
    $password = Get-AutomationVariable -Name 'LinuxPassword'
    $availgroup = Get-AutomationVariable -Name 'Web-tier Availability Group'
    
    $subscription = Get-AzureSubscription -Current
    $location = "Southeast Asia"
    $storage = Get-AzureStorageAccount | where Location -eq $location
    
    Set-AzureSubscription -SubscriptionName $subscription.SubscriptionName -CurrentStorageAccountName $storage.StorageAccountName
    $name = $CloudServiceName
    "Validating $name"
    $CloudService = Get-AzureService -ServiceName $name
    "Found Cloud Service ""$($CloudService.ServiceName)"" in ""$($CloudService.AffinityGroup)"""
    $cert = Get-AzureCertificate -ServiceName $CloudService.ServiceName
    $sshkey = New-AzureSSHKey -KeyPair -Fingerprint $cert.Thumbprint -Path "/home/username/.ssh/authorized_keys"
    
    # Assign unique, random name
    $stamp = get-date -Format "FFFFFFF"
    $VMName = "$VMBaseName$stamp"
    
    InlineScript {
        "Creating VM $($Using:VMName)"
        Select-AzureSubscription $Using:SubscriptionName
        $VM = New-AzureVMConfig -Name $Using:VMName `
                                -InstanceSize "ExtraSmall" `
                                -ImageName $Using:imageName `
                                -AvailabilitySetName $Using:availgroup                     
        
        $VMConfig = Add-AzureProvisioningConfig -Linux `
                                                -VM $VM `
                                                -LinuxUser $Using:username `
                                                -SSHKeyPairs $Using:sshkey `
                                                -password $Using:password
        
        New-AzureVM -ServiceName $Using:CloudService.ServiceName -VM $VMConfig 
    }
}