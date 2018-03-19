

$subsciption = ""
$resourceGroup = ""
$gatewayName = ""
$httpsListenerName = ""
$feIpConfigName = ""
$feUnsecurePortName = "feUnsecurePort80"
$feUnsecureListenerName = "feUnsecureListener"
$redirectConfigName = "redirectHttptoHttps"
$redirectHttpsRuleName = "redirectRuleHttpToHttps"

#-------------------------------------------------------------------------------------------
Set-AzureRmContext -Subscription $subsciption
#------------------------------------------------------------------------------------------


# Get the application gateway
$gw = Get-AzureRmApplicationGateway `
    -Name $gatewayName `
    -ResourceGroupName $resourceGroup

# Get the existing HTTPS listener
$httpslistener = Get-AzureRmApplicationGatewayHttpListener `
    -Name $httpsListenerName `
    -ApplicationGateway $gw

# Get the existing front end IP configuration
$fipconfig = Get-AzureRmApplicationGatewayFrontendIPConfig `
    -Name $feIpConfigName `
    -ApplicationGateway $gw

# Add a new front end port to support HTTP traffic
Add-AzureRmApplicationGatewayFrontendPort `
    -Name $feUnsecurePortName  `
    -Port 80 `
    -ApplicationGateway $gw

# Get the recently created port
$fp = Get-AzureRmApplicationGatewayFrontendPort `
    -Name $feUnsecurePortName `
    -ApplicationGateway $gw

# Create a new HTTP listener using the port created earlier
Add-AzureRmApplicationGatewayHttpListener `
    -Name $feUnsecureListenerName  `
    -Protocol Http `
    -FrontendPort $fp `
    -FrontendIPConfiguration $fipconfig `
    -ApplicationGateway $gw 

# Get the new listener
$listener = Get-AzureRmApplicationGatewayHttpListener `
    -Name $feUnsecureListenerName `
    -ApplicationGateway $gw

# Add a redirection configuration using a permanent redirect and targeting the existing listener
Add-AzureRmApplicationGatewayRedirectConfiguration `
    -Name $redirectConfigName `
    -RedirectType Permanent `
    -TargetListener $httpslistener `
    -IncludePath $true `
    -IncludeQueryString $true `
    -ApplicationGateway $gw

# Get the redirect configuration
$redirectconfig = Get-AzureRmApplicationGatewayRedirectConfiguration `
    -Name $redirectConfigName `
    -ApplicationGateway $gw


# Add a new rule to handle the redirect and use the new listener
Add-AzureRmApplicationGatewayRequestRoutingRule `
    -Name $redirectHttpsRuleName `
    -RuleType Basic `
    -HttpListener $listener `
    -RedirectConfiguration $redirectconfig `
    -ApplicationGateway $gw

# Update the application gateway
Set-AzureRmApplicationGateway -ApplicationGateway $gw 
