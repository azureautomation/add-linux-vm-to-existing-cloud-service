Add Linux VM to existing Cloud Service
======================================

            

Use this Azure Automation Runbook to create a Linux guest in an existing Cloud Service. You need to use the '[Connect to an Azure Subscription](http://gallery.technet.microsoft.com/scriptcenter/Connect-to-an-Azure-f27a81bb)' Runbook
 too for this solution to work. Make sure you set the following variables as Automation Assets:


  *  LinuxUser - username for the guest 
  *  LinuxPassword - password (unfortunately you can't create a machine without a password, even though we're using SSH keys)

  *  ImageName - identifier for your image, use Get-AzureVMImage to enumerate the available images

  *  Web-tier Availability Group - name of Availability Group to add the new machine to. You can remove this line if you don't have an AG


The newly created machine uses the basename variable + random digits to get a unique name. It will use the certificate of the existing Cloud Service to generate it's SSH key.


Ping me on Twitter if I can help!


 

 



        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
