<?php
## .HAMBURG DOMAIN REQUIREMENTS ##
$additionaldomainfields[$tld] = array();

## LOCAL PRESENCE / TRUSTEE SERVICE ##
## NOTE: if you want to offer local presence service, add the trustee service price to the domain registration AND transfer price ##
## for reference: https://requests.whmcs.com/topic/integrate-trustee-service-as-generic-domain-add-on
/*
$additionaldomainfields[$tld][] = array(
    "Name" => "Local Presence",
    "Type" => "dropdown",
    "Options" => ",Registrant and/or Admin-C are domiciled in Hamburg / Use Local Presence Service",
    "Ispapi-Name" => "X-HAMBURG-ACCEPT-TRUSTEE-TAC",
    "Ispapi-Options" => ",1"
);
*/