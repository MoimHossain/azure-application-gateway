
# What is this? 

This repository contains Azure **Resource Manager Templates** that provisions an **Azure Application Gateway** to protect access to an **Azure web site** (Azure web apps). 

# Why?

In order to met higher compliance demands and often as **security best practices**, we want to put an Azure web site behind a **Web Application Firewall (aka WAF)**. The **WAF** provides known malitious security attack vectors mitigations defined in **OWASP top 10** security vulnerabilities. Azure Application Gateway is a layer 7 load balancer that provides WAF out of the box. However, restricting a Web App access with Application Gatway is not trivial. 

To achieve the best isolation and hence protection, we need to provision Azure **Application Service Environment (aka ASE)** and put all the web apps inside the virtual network of the ASE. But ASE deployment has some other consequences, it is Costly, and also, because the web apps are now toally isolated and sitting in a private VNET, dev-team needs to adopt a unusual deployment pipeline to continuously deploy changes into the web apps. 

However, there's an intermidiate solution architecture that provdes WAF without gettting into the complexities that AES brings into the solution architecture. This repository will help addressing that architecture.

# How to do that?

This repository contains a RM template that will provision the following:

- Virtual network (Application Gateway needs a Virtual network).
- Subnet for the Application Gateway into the virtual network.
- Public IP address for the Application Gateway.
- An Application Gateway that pre-configured to protect any Azure Web site.

## How to provision?

Before you run the scripts you need the following: 

- Azure subscription
- Azure web site to guard with WAF
- SSL certificate to configure the Front-End listeners. (This is the Gateway Certificate which will be approached by the end-users of your apps). Typically a PFX file.
-  The password of the PFX file.
- SSL certificate that used to protect the Azure web sites, typically a *.cer file. This can be the *.azurewebsites.net for development purpose. 

You need to fill out the ```parameters.json``` file with the appropriate values, some examples are given below:

```
        "vnetName": {
            "value": "vnetazuregatewaywilkin"
        },
        "appGatewayName": {
            "value": "WilkinAppGateway"
        },
        "azureWebsiteFqdn": {
            "value": "vulnerableapp.azurewebsites.net"
        },
        "frontendCertificateData": {
            "value": ""
        },
        "frontendCertificatePassword": {
            "value": ""
        },
        "backendCertificateData": {
            "value": ""
        }
```

Here, ```frontendCertificateData``` needs to be **Base64 encoded** content of your __pfx__ file.

Once you have the pre-requisites, go to powershell and run:

```
    $> ./deploy.ps1 `
        -subscriptionId "< enter your subscription id >" `
        -resourceGroupName "< enter your resource group name >"
```

This will provision the **Application Gatway** in your resource group. 

# Important !
The final piece of work that you need to do, is to whitelist the IP address of the **Application Gatway** into your Azure Web App. This is to make sure, nobody can manage a direct access to your Azure web app, unless they come through the gateway only.

# Contribute

Contribution is always appreciated.