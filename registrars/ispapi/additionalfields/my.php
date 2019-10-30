<?php
## .MY DOMAIN REQUIREMENTS ##
$additionaldomainfields[$tld] = array();

## LOCAL PRESENCE / TRUSTEE SERVICE ##
## NOTE: if you want to offer local presence service, add the trustee service price to the domain registration AND transfer price ##
## for reference: https://requests.whmcs.com/topic/integrate-trustee-service-as-generic-domain-add-on
/*
$additionaldomainfields[$tld][] = array(
    "Name" => "Local Presence",
    "Type" => "dropdown",
    "Options" => ",Registrant and/or Admin-C are domiciled in Malaysia / Use Local Presence Service",
    "Description" => "<div>If you are not domiciled in Malaysia use the Local presence.<br>If you are domiciled in Malaysia fill the dedicated fields below:</div>",
    "Ispapi-IgnoreForCountries" => "MY",
    "Ispapi-Name" => "X-MY-ACCEPT-TRUSTEE-TAC",
    "Ispapi-Options" => ",1"
);
*/
$additionaldomainfields[$tld][] = array(
    "Name" => "Registrant's Organisation Type",
    "Type" => "dropdown",
    "Options" => implode(",", array(
        "1  - architect firm",
        "2  - audit firm",
        "3  - business pursuant to business registration act(rob)",
        "4  - business pursuant to commercial license ordinance",
        "5  - company pursuant to companies act(roc)",
        "6  - educational institution accredited/registered by relevant government department/agency",
        "7  - farmers organisation",
        "8  - federal government department or agency",
        "9  - foreign embassy",
        "10 - foreign office",
        "11 - government aided primary and/or secondary school",
        "12 - law firm",
        "13 - lembaga (board)",
        "14 - local authority department or agency",
        "15 - maktab rendah sains mara (mrsm) under the administration of mara",
        "16 - ministry of defences department or agency",
        "17 - offshore company",
        "18 - parents teachers association",
        "19 - polytechnic under ministry of education administration",
        "20 - private higher educational institution",
        "21 - private school",
        "22 - regional office",
        "23 - religious entity",
        "24 - representative office",
        "25 - society pursuant to societies act(ros)",
        "26 - sports organisation",
        "27 - state government department or agency",
        "28 - trade union",
        "29 - trustee",
        "30 - university under the administration of ministry of education",
        "31 - valuer, appraiser and estate agent firm"
    )),
    "Required" => false,
    "Ispapi-Name" => "X-MY-REGISTRANT-ORGANIZATION-TYPE",
    "Ispapi-Options" => "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31"
);
$additionaldomainfields[$tld][] = array(
    "Name" => "Registrant ID number",
    "Type" => "text",
    "Required" => false,
    "Ispapi-Name" => "X-REGISTRANT-IDNUMBER"
);
$additionaldomainfields[$tld][] = array(
    "Name" => "Admin-C ID number",
    "Type" => "text",
    "Required" => false,
    "Ispapi-Name" => "X-ADMIN-IDNUMBER"
);
$additionaldomainfields[$tld][] = array(
    "Name" => "Tech-C ID number",
    "Type" => "text",
    "Required" => false,
    "Ispapi-Name" => "X-TECH-IDNUMBER"
);
$additionaldomainfields[$tld][] = array(
    "Name" => "Billing-C ID number",
    "Type" => "text",
    "Required" => false,
    "Ispapi-Name" => "X-BILLING-IDNUMBER"
);